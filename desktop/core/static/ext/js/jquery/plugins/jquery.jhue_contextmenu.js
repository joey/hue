(function( $ ){
     var methods = {
	 init : function( options ) {

	     this.mousedown(
		 function(m){
		     switch (m.which) {
		     case 1: break; //left click
		     case 2: break; //middle click
		     case 3: $('#' + options.menuId).css(
			 {left: m.pageX, top: m.pageY}).toggle();
		     };
                });
	     
	     return this.each(
		 function(){
		     var $this = $(this);
		     var cmenuInnerHtml = 
			 '<div id="' + options.menuId 
			 + '" data-dropdown="dropdown">'
			 + '<ul>'
			 + '<li class="menu">'
			 + '<a class="menu" href="#">' 
			 + options.menuTitle + '</a>'
			 + '<ul class="menu-dropdown">';
		     
		     $(options.items).each(
			 function(i){
			     cmenuInnerHtml += 
			     '<li><a href="#" onclick="' + options.items[i].onSel + '">'
				 + options.items[i].menuText + '</a></li>';
			 });
		     
		     cmenuInnerHtml +='</ul></li></ul></div>'; 

		     var jhue_cmenu = $(cmenuInnerHtml);
		     var cmenu_css = {
			 position: 'absolute',
			 display: 'none'};

  		     jhue_cmenu.css(cmenu_css);
		     
		     $('body').append(jhue_cmenu);
                     $('#jhue_cmenu').dropdown();
		 });
	 }
     };
		     
     $.fn.cmenu = function( method ) {
	 if ( methods[method] ) {

	     return methods[method].apply(
		 this, Array.prototype.slice.call( arguments, 1 ));

	 } else if ( typeof method === 'object' || ! method ) {	     
	     
	     return methods.init.apply( this, arguments );

	 } else {
	     $.error( 'Method ' +  method + ' does not exist on jQuery.cmenu' );
	 }    	 
     };
     
 })( jQuery );