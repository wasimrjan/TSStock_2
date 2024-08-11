/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

function CSA(fd,pg,rf){
    $.ajax({
    url: pg,
    type: 'POST',
    data: fd,
    processData: false,
    contentType: false,
    success : function(data) { 
        rf(data);
    } });
}

function CSA_JSON(JSONClass,pg,rf){
    var json = JSON.stringify(JSONClass);
    $.ajax({
    url: pg,
    type: "POST",
    data:{json:json},
    success : function(data) { 
        rf(data);
    } });
}



