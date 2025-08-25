<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

    <xsl:template name="audioPlayIcon">
        <svg class="icon-play" aria-hidden="true" focusable="false" viewBox="0 0 18 18" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
            <path d="M14.616,9.852L4.524,16.062c-0.47,0.289-1.086,0.143-1.375-0.328C3.051,15.577,3,15.396,3,15.211V2.79c0-0.552,0.448-1,1-1c0.185,0,0.367,0.051,0.524,0.148l10.092,6.21c0.47,0.29,0.616,0.905,0.327,1.375C14.861,9.657,14.75,9.77,14.616,9.852z"/>
        </svg>
    </xsl:template>

    <xsl:template name="audioPauseIcon">
        <svg class="icon-pause" aria-hidden="true" focusable="false" viewBox="0 0 18 18" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
            <path d="M4,3h3c0.552,0,1,0.448,1,1v10c0,0.553-0.448,1-1,1H4c-0.552,0-1-0.447-1-1V4C3,3.448,3.448,3,4,3z"/>
            <path d="M11,3h3c0.553,0,1,0.448,1,1v10c0,0.553-0.447,1-1,1h-3c-0.553,0-1-0.447-1-1V4C10,3.448,10.447,3,11,3z"/>
        </svg>
    </xsl:template>

    <xsl:template name="audioStopIcon">
        <svg class="icon-stop" aria-hidden="true" focusable="false" viewBox="0 0 18 18" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
		    <path d="M13,3H5C3.9,3,3,3.9,3,5v8c0,1.1,0.9,2,2,2h8c1.1,0,2-0.9,2-2V5C15,3.9,14.1,3,13,3z"/>
        </svg>
    </xsl:template>

    <xsl:template name="audioStartRecordIcon">
        <svg class="icon-record-start" viewBox="0 0 28.53 26" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
            <path id="path-1" class="cls-2" style="fill: #fff; stroke-width: 0px; fill-rule: evenodd;" d="m11.59,6.2c0-1.65,1.35-3,3-3s3,1.35,3,3v8c0,1.65-1.35,3-3,3s-3-1.35-3-3V6.2Zm3,13c-2.76,0-5-2.24-5-5V6.2c0-2.76,2.24-5,5-5s5,2.24,5,5v8c0,2.76-2.24,5-5,5Zm8-5c0,4.08-3.07,7.44-7.01,7.93,0,.02.01.04.01.07v2c0,.55-.45,1-1,1s-1-.45-1-1v-2s.01-.04.01-.07c-3.95-.49-7.01-3.86-7.01-7.93,0-.55.45-1,1-1s1,.45,1,1c0,3.31,2.69,6,6,6s6-2.69,6-6c0-.55.45-1,1-1s1,.45,1,1Z"/>
        </svg>
    </xsl:template>

    <xsl:template name="audioStopRecordIcon">
        <svg class="icon-record-stop" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
            <circle id="object" stroke="#ffffff" fill="none" stroke-width="2" cx="12" cy="12" r="11"></circle>
            <rect id="Rectangle" fill="#ffffff" fill-rule="evenodd" x="8" y="8" width="8" height="8" rx="1"></rect>
        </svg>
    </xsl:template>

</xsl:stylesheet>
