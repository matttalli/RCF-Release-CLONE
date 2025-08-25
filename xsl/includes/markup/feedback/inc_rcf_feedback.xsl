<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:template match="feedback" >
		<div class="{ normalize-space(concat('feedback dev-feedback ', @class))}"
			aria-hidden="true"
			aria-live="polite"
			data-rcfTranslate=""
			aria-label="[ components.feedback.label ]"
		>
			<xsl:apply-templates/>
		</div>
	</xsl:template>

</xsl:stylesheet>

