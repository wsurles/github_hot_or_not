<script type='text/javascript'>

$(document).ready(function(){

	if (window.location.hash) {
		var thisvar = window.location.hash.substr(1);
		var tabContentLink = $('.tab-content a[data-value="'+thisvar+'"]');
		tabPaneName = tabContentLink.parents('.tab-pane').data('value');
		$('a[data-value="' + tabPaneName + '"]').click();
		tabContentLink.click();
	}

	$('.tab-content a').click(function(e){
		if ($(this).data('value')){
			document.location.hash = $(this).data('value');
		}
	});

});//end doc ready

</script>