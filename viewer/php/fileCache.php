<?php

function createFileCacheIfRequired() {
	if(!file_exists(RCF_FILE_CACHE)) {
		logError('[FILE-CACHE] : creating cache folder : ' . RCF_FILE_CACHE);
		mkdir(RCF_FILE_CACHE);
		updateCacheLastAccessedTime();
	}
}

function updateCacheLastAccessedTime() {
	touch(RCF_CACHE_DETECTOR);
}

function clearFileCache() {
	logError('[FILE-CACHE] : Clearing file cache at [' . RCF_FILE_CACHE . ']');
	$files = glob(RCF_FILE_CACHE . '*');
	foreach($files as $file) {
		if(is_file($file)) {
			unlink($file);
		}
	}
	updateCacheLastAccessedTime();
	logError('[FILE-CACHE] : Cache cleared');

	$fileNamesCacheName = CACHE_NAME . '_otherfiles';
	logError('[FILE-CACHE] - clearing session cache [' . $fileNamesCacheName . ']');
	unset($_SESSION[$fileNamesCacheName]);
}

function cacheNeedsRebuilding() {
	if(file_exists(RCF_CACHE_DETECTOR)) {
		$lastAccessedTime = filemtime(RCF_CACHE_DETECTOR);
		// change cache from 1 hour because some servers get confused between UTC / GMT 1+ hour difference and never cache !
		$fileOlderThanTenMinutes = (time() - filemtime(RCF_CACHE_DETECTOR)) > (600);
		// return (filemtime(RCF_CACHE_DETECTOR) < (time() - (60 * 12)));
		return $fileOlderThanTenMinutes;
	} else {
		return true;
	}
}


// TOC cache functions
function getTocCachedData($path) {
    if(USE_TRANSFORM_CACHE=='y') {
        $cachedDataFileName = getTocCacheFileName($path);
        if(file_exists($cachedDataFileName)) {
            return file_get_contents($cachedDataFileName);
        }
    }
}

function setTocCachedData($path, $data) {
    if(USE_TRANSFORM_CACHE=='y') {
        $cachedDataFileName = getTocCacheFileName($path);
        file_put_contents($cachedDataFileName, $data);
    }
}

function getTocCacheFileName($path) {
    return RCF_FILE_CACHE . md5($path) . '-toc-data';
}

function removeTocCachedData($path) {
    if(USE_TRANSFORM_CACHE=='y') {
		// remove all cached files up to the 'Level' in the hierarchy to make sure all titles are refreshed when required
		$done = false;

		// RCF-10251 - check for windows paths when 'exploding' paths !
		// - remember, files in the activity cache are all stored with unix (forward) slashes
		//   so exploding them with `\` on windows will not work and the loop would go on forever here !
		//
		if(DIRECTORY_SEPARATOR == '\\') {
			$currentPath = str_replace("/", "\\", $path);
		} else {
			$currentPath = $path;
		}

		$tries = 0;
		while(!$done) {
			$currentPathParts = explode(DIRECTORY_SEPARATOR, $currentPath);
			$currentFolder = array_pop($currentPathParts);
			if($currentFolder === 'project') {
				$done = true;
			} else {
				$removeFolder = join(DIRECTORY_SEPARATOR, $currentPathParts);

				$cachedFileName = getTocCacheFileName($currentPath);
				if(file_exists($cachedFileName)) {
					unlink($cachedFileName);
				}
				$currentPath = $removeFolder;
				$tries = $tries + 1;
				// 10 levels deep should be more than enough, eg (L0/U01/S01/EL01/AS01/A01) = 6 levels
				if($tries > 10) {
					$done = true;
					logError('[FILE-CACHE] : ERROR - could not remove TOC cache file for path [' . $path . '] - too deep ! (more than 10 tries)'  );
				}
			}
		}
    }
}


// first time this PHP page is loaded, create the folder for the file cache if necessary
createFileCacheIfRequired();

// check if file cache needs rebuilding and act accordingly
if(cacheNeedsRebuilding()) {
	logError('[FILE-CACHE] : rebuilding cache after inactivity....');
	clearFileCache();
} else {
	updateCacheLastAccessedTime();
}

?>
