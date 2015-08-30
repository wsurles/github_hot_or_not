<script type='text/javascript'>

// This will make a hash in the url so each individual analysis is linkable
// $(document).ready(function(){

// 	if (window.location.hash) {
// 		var thisvar = window.location.hash.substr(1);
// 		var tabContentLink = $('.tab-content a[data-value="'+thisvar+'"]');
// 		tabPaneName = tabContentLink.parents('.tab-pane').data('value');
// 		$('a[data-value="' + tabPaneName + '"]').click();
// 		tabContentLink.click();
// 	}

// 	$('.tab-content a').click(function(e){
// 		if ($(this).data('value')){
// 			document.location.hash = $(this).data('value');
// 		}
// 	});

// });//end doc ready

$(document).ready(function(){

	if (window.location.hash) {
		var thisvar = window.location.hash.substr(1);
		var tabContentLink = $('.tab-content a[data-value="'+thisvar+'"]');
		// tabPaneName = tabContentLink.parents('.tab-pane').data('value');
		tabPaneName = tabContentLink('.tab-pane').data('value');
		$('a[data-value="' + tabPaneName + '"]').click();
		tabContentLink.click();
	}
	$('a[data-value]').click(function() {
		var $elem = $(this);
		var url = $elem.first().attr('data-value');
		// var $parents = $elem.parents('[data-value]');
		// if($parents.length > 0) {
		// 	url = $parents.first().attr('data-value') + "_" + url;
		// }
		
	});

});//end doc ready

</script>