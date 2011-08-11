// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
// 

$(document).ready(function(){
    startTime();
    $(".summary").changeWithAjax();
    $(".summary").mouseoverWithAjax();
    $(".summary").mouseoutWithAjax();
});
    
function startTime(){
    var today=new Date();
    document.getElementById('timer').innerHTML=today;
    t=setTimeout('startTime()',500);
}

jQuery.ajaxSetup({ 
    'beforeSend': function(xhr) {
        xhr.setRequestHeader("Accept", "text/javascript")
    }
})

jQuery.fn.changeWithAjax = function() {
    this.change(function() {
        // alert($(this).parents().attr("action"));
        // alert($(this).parents().serialize());
        $.post($(this).parents().attr("action"), 
            $(this).parents().serialize() + ';commit=Update', 
            null, "script");   
    }); 
}

jQuery.fn.mouseoverWithAjax = function() {
    this.mouseover(function() {
        $(this).css("background-color","yellow");
    });
}

jQuery.fn.mouseoutWithAjax = function() {
    this.mouseout(function() {
        $(this).css("background-color","white");
    });
}



