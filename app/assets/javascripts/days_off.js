$(function() {
    $('[data-id=datepicker]').datepicker({ dateFormat: "yy-mm-dd" });

    $('[data-id=range]').hide();
    $('[data-id=day-length]').change(function() { 
        if ($('[data-id=day-length]').val() == 'half_day') {   
            $('[data-id=range]').show();
        } else {    
            $('[data-id=range]').hide();
        }
    });
});
