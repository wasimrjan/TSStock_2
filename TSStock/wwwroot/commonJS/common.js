/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
function ExportToExcelTable(x,lst)
{
    try{
    var tab_text = '<table border="1px" style="font-size:12px">';
    var i = 0;
    var tab = document.getElementById(x); // id of table
    var lines = tab.rows.length;
    
    // the first headline of the table
    if (lines > 0) {
        tab_text = tab_text + '<tr bgcolor="#DFDFDF">';

        for(j=0;j<tab.rows[1].cells.length;j++){
            if(!checkinList(lst,j))
                tab_text = tab_text + '<td>' + tab.rows[0].cells[j].innerHTML + '</td>';
        }
        tab_text = tab_text + '</tr>';


    // table data lines, loop starting from 1
    for (i = 1 ; i < lines; i++) {     
        tab_text = tab_text + '<tr>';
        for(j=0;j<tab.rows[i].cells.length;j++){
            if(!checkinList(lst,j))
                tab_text = tab_text + '<td>' + tab.rows[i].cells[j].innerHTML + '</td>';
        }
        tab_text = tab_text + '</tr>';
    }

    tab_text = tab_text + "</table>";
    tab_text = tab_text.replace(/<a^>]*>|<\/a>/g, "");             //remove if u want links in your table
    tab_text = tab_text.replace(/<img[^>]*>/gi,"");                 // remove if u want images in your table
    tab_text = tab_text.replace(/<input[^>]*>/gi,"");    // reomves input 
    tab_text = tab_text.replace(/<select>(.|\n)*?<\/select>/g, "");    // reomves input 
    // console.log(tab_text); // aktivate so see the result (press F12 in browser)

    var ua = window.navigator.userAgent;
    var msie = ua.indexOf("MSIE "); 

     // if Internet Explorer
    if (msie > 0 || !!navigator.userAgent.match(/Trident.*rv\:11\./)) {
        txtArea1.document.open("txt/html","replace");
        txtArea1.document.write(tab_text);
        txtArea1.document.close();
        txtArea1.focus(); 
        sa = txtArea1.document.execCommand("SaveAs", true, "DataTableExport.xls");
    }  
    else // other browser not tested on IE 11
        sa = window.open('data:application/vnd.ms-excel,' + encodeURIComponent(tab_text));  
    }
    }
    catch(eee)
    {
        alert(eee);
    }
    return (sa);
}

function getCheckedClass(cls){
    var rs = "";
    for(i=0;i<$(cls).length;i++){
        if($(cls).eq(i).prop("checked")){
        rs = rs + "," + $(cls).eq(i).val(); 
        }
    }
    if(rs!="")
        return rs.substring(1);
    else
        return rs;
}


function checkUMC_Format(umc)
{
    if(umc.length!=9)
        return false;
    else
    {
        var i,ch;
        umc = umc.toUpperCase();
        for(i=0;i<=8;i++){
            ch = umc.substr(i,1);
            if(i!=4){
            if(!(ch>='0' && ch<='9'))
                return false;
            }
            else{
                if(!(ch>='A' && ch<='Z'))
                    return false;
                }
            }
    }
    return true;
}