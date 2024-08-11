/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

function HC_Date(pdt)
{
    var dt = null;
    

    if(pdt!==undefined){
        var ard = pdt.toString().split('.');
        dt = new Date(ard[2],ard[1]-1,ard[0]);
    }
    else
        dt = new Date();
    
    this.day = dt.getDate();
    this.month = dt.getMonth() + 1;
    this.year = dt.getFullYear();
    this.weekday = dt.getDay();
    
    this.ValidateUIDate = function(x)
    {
        var ar = x.split('.');
        var dy = eval(ar[0]);
        var mn = eval(ar[1]);
        var yr = eval(ar[2]);
        
        if (!(mn>=1 && mn<=12))
            return false;
        
        var ldm = eval(this.LastDayofMonth(mn,yr));
        if (!(dy>=1 && dy<=ldm))
            return false;
        
        return true;
    };
    
    this.setDate = function(x)
    {
        if(this.ValidateUIDate(x))
        {
             var ar = x.split('.');
             this.day = eval(ar[0]);
             this.month = eval(ar[1]);
             this.year = eval(ar[2]);
        }
    };
    
    this.getDate = function(){
        return new Date(this.getUIDate());
    };
    
    this.LastDayofMonth = function(pmn,pyr){
        var mn = pmn || this.month;
        var yr = pyr || this.year;
        
        if(mn===1 || mn===3 || mn===5 || mn=== 7 || mn===8 || mn===10 || mn===12){
            return 31;
        }
        else{
            
            if(mn===4 || mn===6 || mn===9 || mn===11)
                return 30;
            else{
                if(mn===2){
                    if(this.isLeapYear(yr))
                        return 29;
                    else
                        return 28;
                }
            }
        }
    };
    
    this.FirstWeekIndexofMonth = function(pdt)
    {
        if(pdt===undefined)
            return (new Date("1-"+this.charMonth().substring(0,3)+"-"+this.year)).getDay();
        else{
            var dt = new Date(pdt);
            return (new Date("1-"+this.charMonth(dt.getMonth() + 1)+"-"+this.year)).getDay();
        }
    };
    
    this.charMonth = function(pmn)
    {
        var mn = pmn || this.month; 
        if(mn===1)
            return "January";
        if(mn===2)
            return "February";
        if(mn===3)
            return "March";
        if(mn===4)
            return "April";
        if(mn===5)
            return "May";
        if(mn===6)
            return "June";
        if(mn===7)
            return "July";
        if(mn===8)
            return "August";
        if(mn===9)
            return "September";
        if(mn===10)
            return "October";
        if(mn===11)
            return "November";
        if(mn===12)
            return "December";
        return "";
    };
    
    this.getUIDate = function()
    {
        var mn = "",dy = "";
        if(this.month.toString().length===1)
            mn = "0" + this.month;
        else
            mn = this.month;
        if(this.day.toString().length===1)
            dy = "0" + this.day;
        else
            dy = this.day;
        return dy + "." + mn + "." + this.year;
    };
    
    this.getDBDate = function()
    {
        var mn = "",dy = "";
        if(this.month.toString().length===1)
            mn = "0" + this.month;
        else
            mn = this.month;
        if(this.day.toString().length===1)
            dy = "0" + this.day;
        else
            dy = this.day;
        
        return this.year + "-" + mn + "-" + dy;
    };
    
    this.numMonth = function(pmn)
    {
        var mn = pmn;
        if(mn==="January")
            return 1;
        if(mn==="February")
            return 2;
        if(mn==="March")
            return 3;
        if(mn==="April")
            return 4;
        if(mn==="May")
            return 5;
        if(mn==="June")
            return 6;
        if(mn==="July")
            return 7;
        if(mn==="August")
            return 8;
        if(mn==="September")
            return 9;
        if(mn==="October")
            return 10;
        if(mn==="November")
            return 11;
        if(mn==="December")
            return 12;
        return "";
    };
    
    
    this.getMonthStartDate = function()
    {
        var tdt = new HC_Date(this.getUIDate());
        return tdt.addDays((this.day - 1) * -1);
    };
    
    this.getMonthEndDate = function()
    {
        var tdt = new HC_Date(this.getUIDate());
        return tdt.addDays(this.LastDayofMonth() - this.day);
    };
    
    this.getWeekStartDate = function()
    {
        var tdt = new HC_Date(this.getUIDate());
        if(this.weekday===0)
            return tdt.addDays(-6);
        if(this.weekday===1)
            return tdt.addDays(0);
        if(this.weekday===2)
            return tdt.addDays(-1);
        if(this.weekday===3)
            return tdt.addDays(-2);
        if(this.weekday===4)
            return tdt.addDays(-3);
        if(this.weekday===5)
            return tdt.addDays(-4);
        if(this.weekday===6)
            return tdt.addDays(-5);
    };
    
    this.getWeekEndDate = function()
    {
        var tdt = new HC_Date(this.getUIDate());
        if(tdt.weekday===0)
            return tdt.addDays(0);
        if(this.weekday===1)
            return tdt.addDays(6);
        if(this.weekday===2)
            return tdt.addDays(5);
        if(this.weekday===3)
            return tdt.addDays(4);
        if(this.weekday===4)
            return tdt.addDays(3);
        if(this.weekday===5)
            return tdt.addDays(2);
        if(this.weekday===6)
            return tdt.addDays(1);
    };
    
    
    this.charWeekday = function(pmn)
    {
        var mn = null;
        if(pmn!==undefined)
            mn = pmn; 
        else
            mn = this.weekday;
        if(mn===0)
            return "Sunday";
        else
        if(mn===1)
            return "Monday";
        else
        if(mn===2)
            return "Tuesday";
        else
        if(mn===3)
            return "Wednesday";
        else
        if(mn===4)
            return "Thursday";
        else
        if(mn===5)
            return "Friday";
        else
        if(mn===6)
            return "Saturday";
        return "";
    };
    
    this.numWeekday = function(pmn)
    {
        var mn = pmn;
        if(mn==="Sunday")
            return 0;
        if(mn==="Monday")
            return 1;
        if(mn==="Tuesday")
            return 2;
        if(mn==="Wednesday")
            return 3;
        if(mn==="Thursday")
            return 4;
        if(mn==="Friday")
            return 5;
        if(mn==="Saturday")
            return 6;
        return "";
    };
    
    this.isLeapYear = function(pyr){
        var yr = pyr || this.year;
        if(yr % 100 === 0){
            if(yr % 400 ===0)
                return true;
            else
                return false;
        }
        else{
            if(yr % 4 === 0)
                return true;
            else
                return false;
        }
        return false;
    };
    
    this.nextDay = function(pdt){
        if(pdt!==undefined){
           var dt = new HC_Date(pdt);
           return dt.addDays(1);
        }
        else{
            return this.addDays(1);
        }
    };
    
    this.prevDay = function(pdt){
        if(pdt!==undefined){
           var dt = new HC_Date(pdt);
           return dt.addDays(-1);
        }
        else{
            return this.addDays(-1);
        }
    };
    
    
    this.nextWeek = function(pdt){
        if(pdt!==undefined){
           var dt = new HC_Date(pdt);
           return dt.addDays(7);
        }
        else{
            return this.addDays(7);
        }
    };
    
    this.prevWeek = function(pdt){
        if(pdt!==undefined){
           var dt = new HC_Date(pdt);
           return dt.addDays(-7);
        }
        else{
            return this.addDays(-7);
        }
    };
    
    
    this.nextMonth = function(pdt){
        if(pdt!==undefined){
           var dt = new HC_Date(pdt);
           return dt.addMonths(1);
        }
        else{
            return this.addMonths(1);
        }
    };
    
    this.prevMonth = function(pdt){
        if(pdt!==undefined){
           var dt = new HC_Date(pdt);
           return dt.addMonths(-1);
        }
        else{
            return this.addMonths(-1);
        }
    };
    
    this.nextYear = function(pdt){
        if(pdt!==undefined){
           var dt = new HC_Date(pdt);
           return dt.addYears(1);
        }
        else{
            return this.addYears(1);
        }
    };
    
    this.prevYear = function(pdt){
        if(pdt!==undefined){
           var dt = new HC_Date(pdt);
           return dt.addYears(-1);
        }
        else{
            return this.addYears(-1);
        }
    };
    
    this.addYears = function(pyr,pdt){
        if(pdt!==undefined){
           var dt = new HC_Date(pdt);
           return dt.addYears(pyr);
        }
        else{
            this.year = this.year + pyr;
            if(this.month===2 && this.day===29)
               if(!this.isLeapYear(nyr))
                   this.day = 28;
           return this;
        }
    };
    
    this.addMonths = function(pmn,pdt){
        if(pdt!==undefined){
           var dt = new HC_Date(pdt);
           return dt.addMonths(pmn);
        }
        else{
            if(pmn>=0){
                
                var rmmn = 12 - this.month;
                if(pmn<=rmmn){
                    this.month = this.month + pmn;
                }
                else{
                    pmn = pmn - rmmn;
                    this.year++;
                    if(pmn<=12)
                        this.month = pmn;
                    else{
                        var ofyr = Math.floor(pmn / 12);
                        var ofmn = pmn % 12;
                        this.year = this.year + ofyr;
                        this.month = ofmn;
                    }
                }
            }
            else{
                pmn = Math.abs(pmn);
                var rmmn = this.month;
                if(pmn<rmmn)
                {
                    this.month = this.month - pmn;
                }
                else
                {
                    pmn = pmn - rmmn;
                    this.year--;
                    this.month = 12;
                    if(pmn<12)
                        this.month = 12 - pmn;
                    else{
                        var ofyr = Math.floor(pmn / 12);
                        var ofmn = pmn % 12;
                        this.year = this.year - ofyr;
                        this.month = 12 - ofmn;
                    }
                }
            }
            var nldy = this.LastDayofMonth(this.month,this.year);
            if(this.day>nldy)
                this.day = nldy;
            return this;
        }
    };
    
    this.addDays = function(pday,pdt){
        if(pdt!==undefined){
           var dt = new HC_Date(pdt);
           return dt.addDays(pday);
        }
        else{
            if(pday>=0){
                var rmmn = this.LastDayofMonth() - this.day;
                if(pday<=rmmn)
                {
                    this.day = this.day + pday;
                }
                else{
                    var t = pday;
                    this.day = this.day + rmmn;
                    t = t - rmmn;
                    this.month++;
                    if(this.month>12){
                        this.month = 1;
                        this.year++;
                    }
                    while(t>0)
                    {
                        //alert(t);
                        var nldmn = this.LastDayofMonth();
                        if(t<=nldmn){
                            this.day = t;
                            t = 0;
                        }
                        else{
                            t = t - nldmn;
                            this.month++;
                            if(this.month>12){
                                this.month = 1;
                                this.year++;
                            }
                        }
                    }
                }
            }
            else{
                pday = Math.abs(pday);
                var rmmn = this.day;
                if(pday<rmmn)
                {
                    this.day = this.day - pday;
                }
                else{
                    var t = pday;
                    t = t - this.day;
                    this.month--;
                    if(this.month===0){
                        this.month = 12;
                        this.year--;
                    }
                    this.day = this.LastDayofMonth();
                    while(t>0)
                    {
                        var nldmn = this.LastDayofMonth();
                        if(t<nldmn){
                            this.day = this.day - t;
                            t = 0;
                        }
                        else{
                            t = t - nldmn;
                            this.month--;
                            if(this.month===0){
                                this.month = 12;
                                this.year--;
                            }
                            this.day = this.LastDayofMonth();
                        }
                    }
                }
            }
            return this;
        }
    };
};


function HC_Validation(CTLName,pValidationType,pLabel)
{
    /*
    
    Validation Type : (Validation Type)
    
        a) ND : for decimal only Numbers (10100) with prefix of minus symbox - 
        a) D : for decimal only Numbers (10100) with no extra characters
        b) NF : for floating point value like 2.5 , 3.5 etc inclues (.) with prefix of minus symbox -.
        b) F : for floating point value like 2.5 , 3.5 etc inclues (.) .
        c) M : for mobile numbers only 10 digits allowed with no extra characters
        d) L : for land line numbers with 11 12 13 digits and may contain - 
        e) E : for email id format like test@test.com
        f) W : for website format format like http(s)://www.king.com
        g) C : for PINCODE format contains only 6 digit
        h) S : for String format contains any character
        i) DT : for date format (dd-mm-yyyy)
        j) TM : for date format (00:00)
        k) PAN : for pan card format AAAAA9999A
        l) UID : for UID card format 0000-0000-0000
        m) IP : for IP Address format 000.000.000.000

*/
    
    this.id = "#" + CTLName || "";
    this.Pattern = "";
    this.Messge = "";
    this.ValidationType = pValidationType || "S";
    this.Label = pLabel || "";
    
    this.selfValidateBlank = function(){
        var vl = $(this.id).val();
        if(vl.trim()==="")
        {
            $(id).removeClass("is-valid");
            $(id).addClass("is-invalid");
            $(id+"_ermsg").html("Please Enter " + this.Label);
            $(id).focus();
            $(id).select();
            return false;
        }
        else{
            $(id).addClass("is-valid");
            $(id).removeClass("is-invalid");
            $(id).html("");
            return true;
        }
    };
    
    this.validateBlank = function(tb,vl,lbl){
        if(vl==="")
            vl = $("#"+tb).val();
        
        if(vl.trim()==="")
        {
            $("#"+tb).removeClass("is-valid");
            $("#"+tb).addClass("is-invalid");
            $("#"+tb+"_ermsg").html("Please Enter " + lbl);
            return false;
        }
        else{
            $("#"+tb).addClass("is-valid");
            $("#"+tb).removeClass("is-invalid");
            $("#"+tb+"_ermsg").html("");
            return true;
        }
    };
    
    this.getValidationMessage = function(vtp){
        
        var msg  = "";
        
        if(vtp==="IP" || vtp==="UID" || vtp==="PAN" || vtp==="DT" || vtp==="ND" || vtp==="NF" || vtp==="D" || vtp==="F" || vtp==="M" || vtp==="L" || vtp==="E" || vtp==="W" || vtp==="C")
        {
            if(vtp==="ND"){
                msg = "only number with no decimal points.";
            }
            if(vtp==="D"){
                msg = "only positive number with no decimal points.";
            }
            if(vtp==="F"){
                msg = "only number with dot (.)";
            }
            if(vtp==="NF"){
                msg = "only number with dot (.)";
            }
            if(vtp==="M"){
                msg = "only mobile number format 10 digits";
            }
            if(vtp==="L"){
                msg = "only number with dash (-)";
            }
            if(vtp==="DT"){
                msg = "only date format (dd-mm-yyyy)";
            }
            if(vtp==="PAN"){
                msg = "only pan card format (AAAAA9999A)";
            }
            if(vtp==="UID"){
                msg = "only UID (Aadhar) card format (0000-0000-0000)";
            }
            if(vtp==="C"){
                msg = "only pincode format 6 digits (000000)";
            }
            if(vtp==="E"){
                msg = "only email format (xxx@xxx.xxx)";
            }
            if(vtp==="W"){
                msg = "only webmail format (http://www.xxx.com)";
            }
            if(vtp==="IP"){
                msg = "only IP Address format (000.000.000.000)";
            }
        }
        return msg;    
    };
    
    this.getPattern = function(vtp){
        var patt = "";
        if(vtp==="IP" || vtp==="UID" || vtp==="PAN" || vtp==="DT" || vtp==="ND" || vtp==="NF" || vtp==="D" || vtp==="F" || vtp==="M" || vtp==="L" || vtp==="E" || vtp==="W" || vtp==="C")
        {
            if(vtp==="ND"){
                patt = /^[-]?\d+$/;
            }
            if(vtp==="D"){
                patt = /^\d+$/;
            }
            if(vtp==="F"){
                patt = /^((\.\d+)|(\d+(\.\d+)?))$/;
            }
            if(vtp==="NF"){
                patt = /^[-]?((\.\d+)|(\d+(\.\d+)?))$/;
            }
            if(vtp==="M"){
                patt = /^\d{10}$/;
            }
            if(vtp==="L"){
                patt = /^\d{9}|\d{10}|\d{11}|\d{12}|\d{13}$/;
            }
            if(vtp==="DT"){
                patt = /^(0?[1-9]|[12][0-9]|3[01])[\-](0?[1-9]|1[012])[\-]\d{4}$/;
            }
            if(vtp==="PAN"){
                patt = /^([a-zA-Z]{5})(\d{4})([a-zA-Z]{1})$/;
            }
            if(vtp==="UID"){
                patt = /^(\d{4})\-(\d{4})\-(\d{4})$/;
            }
            if(vtp==="C"){
                patt = /^\d{6}$/;
            }
            if(vtp==="E"){
                patt = /^\b[A-Z0-9._%-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b$/i;
            }
            if(vtp==="W"){
                patt = /^(http|https)?:\/\/[a-zA-Z0-9-\.]+\.[a-z]{2,4}/;
            }
            if(vtp==="IP"){
                patt = /^(\d|[1-9]\d|1\d\d|2([0-4]\d|5[0-5]))\.(\d|[1-9]\d|1\d\d|2([0-4]\d|5[0-5]))\.(\d|[1-9]\d|1\d\d|2([0-4]\d|5[0-5]))\.(\d|[1-9]\d|1\d\d|2([0-4]\d|5[0-5]))$/;
            }
        }
        return patt;
    };
    
    this.assignValidationTP = function(vtp)
    {
        var patt,msg;
        if(vtp==="IP" || vtp==="UID" || vtp==="PAN" || vtp==="DT" || vtp==="ND" || vtp==="NF" || vtp==="D" || vtp==="F" || vtp==="M" || vtp==="L" || vtp==="E" || vtp==="W" || vtp==="C")
        {
            patt = this.getPattern(vtp);
            msg = this.getValidationMessage(vtp);
        }
        
        this.Pattern = patt;
        this.Messge = msg;
        
    };
    
    this.getValidationStatus = function(data,vtp){
      
        return this.getPattern(vtp).test(data);
        
    };
    
    this.validateVTP = function(tb,vl,vtp){
        var id = "#"+tb;
        if(vl==="")
            vl = $("#"+tb).val();
        this.assignValidationTP(vtp);
        if(vl!==""){
            if(!this.Pattern.test(vl)){
                $(id+"_ermsg").html(this.Messge);
                $(id).removeClass("is-valid");
                $(id).addClass("is-invalid");
                return false;
            }
            else{
                $(id+"_ermsg").html("");
                $(id).removeClass("is-invalid");
                $(id).addClass("is-valid");
                return true;
            }
        }
        else
        {
            $(id+"_ermsg").html("");
            $(id).removeClass("is-invalid");
            $(id).removeClass("is-valid");
            return true;
        }
        return true;
    };
    
    this.selfValidateVTP = function(vl){
        var id = this.id;
        this.assignValidationTP(this.ValidationType);
        if(vl!==""){
            if(!this.Pattern.test(vl)){
                $(id+"_ermsg").html(this.Messge);
                $(id).removeClass("is-valid");
                $(id).addClass("is-invalid");
                $(id).focus();
                return false;
            }
            else{
                $(id+"_ermsg").html("");
                $(id).removeClass("is-invalid");
                $(id).addClass("is-valid");
                return true;
            }
        }
        else
        {
            $(id+"_ermsg").html("");
            $(id).removeClass("is-invalid");
            $(id).removeClass("is-valid");
            return true;
        }
        return true;
    };
};


function HC_GroupBoxes(pContainer)
{
    this.GroupBoxes = [];
    this.GroupBoxesName = [];
    this.Container = pContainer || "";
    
    this.Create = function(GBName)
    {
        this.GroupBoxesName.push(GBName);
        var gb = new HC_GroupBox(GBName,this.Container);
        gb.Create();
        this.GroupBoxes.push(gb);
        return this.GroupBoxesName.length - 1;
    };
    
    this.Dispose = function()
    {
        for(var i=0;i<this.GroupBoxes.length;i++)
        {
            this.GroupBoxes[i].Dispose();
        }
        this.GroupBoxes = [];
        this.GroupBoxesName = [];
    };
    
    this.removeGroupBox = function(idx)
    {
        this.GroupBoxes[idx].removeGroupBox();
    };
    
    this.removeGroupBoxName = function(GBName)
    {
        var idx = this.GroupBoxesName.indexOf(GBName);
        this.GroupBoxes[idx].removeGroupBox();
    };
    
    this.showAllHeader = function()
    {
        for(i=0;i<this.GroupBoxes.length;i++)
        {
            this.GroupBoxes[i].showHeader(i);
        }
    };
    
    this.showAllFooter = function()
    {
        for(i=0;i<this.GroupBoxes.length;i++)
        {
            this.GroupBoxes[i].showFooter(i);
        }
    };
    
    this.hideAllHeader = function()
    {
        for(i=0;i<this.GroupBoxes.length;i++)
        {
            this.GroupBoxes[i].hideHeader(i);
        }
    };
    
    this.hideAllFooter = function()
    {
        for(i=0;i<this.GroupBoxes.length;i++)
        {
            this.GroupBoxes[i].hideFooter(i);
        }
    };
   
    this.setHeader = function(idx,text)
    {
        if(idx<this.GroupBoxes.length)
            this.GroupBoxes[idx].setHeader(text);
    };
    
    this.setFooter = function(idx,text)
    {
        if(idx<this.GroupBoxes.length)
            this.GroupBoxes[idx].setFooter(text);
    };
    
    this.addInBody = function(idx,obj)
    {
        if(idx<this.GroupBoxes.length)
            this.GroupBoxes[idx].addInBody(obj);

    };
    
    this.isGBExists = function(GBName)
    {
        if(this.GroupBoxesName.indexOf(GBName)>=0)
            return true;
        else
            return false;
    };
    
    this.getGBIndex = function(GBName)
    {
        return this.GroupBoxesName.indexOf(GBName);
    };
};

function HC_GroupBox(GBName,pContainer)
{
    this.GBName = pContainer + "_" + GBName;
    this.Container = pContainer || "";
    this.Tabs = new HC_Tabs(this.Container+"_"+this.GBName+"_body");
    this.Rows = new HC_BSRows(this.Container+"_"+this.GBName+"_body");
    
    this.Create = function()
    {
        var dv = $("<div class='card' id='" + this.GBName + "'></div>");
        var dvhead = $("<div class='card-header' id='" + this.GBName + "_head'></div>");
        var dvbody = $("<div class='card-body' id='" + this.GBName + "_body' style='padding:0px;padding-top:5px;'></div>");
        var dvfoot = $("<div class='card-footer' id='" + this.GBName + "_foot'></div>");
        dv.append(dvhead);
        dv.append(dvbody);
        dv.append(dvfoot);
        $("#"+this.Container).append(dv);
    };
    
    this.Dispose = function()
    {
        $("#"+this.GBName).remove();   
        this.Tabs.Dispose();
        this.Rows.Dispose();
    };
    
    this.removeGroupBox = function()
    {
        this.GrouBoxes.remove(this.GBName);
        $("#"+this.GBName).remove();
    };
    
    this.showHeader = function()
    {
        $("#"+this.GBName+"_head").show();
    };
    
    this.showFooter = function()
    {
        $("#"+this.GBName+"_foot").show();
    };
    
    this.hideHeader = function()
    {
        $("#"+this.GBName+"_head").hide();
    };
    
    this.hideFooter = function()
    {
        $("#"+this.GBName+"_foot").hide();
    };
    
    this.setHeader = function(text)
    {
        $("#"+this.GBName+"_head").html(text);
    };
    
    this.setFooter = function(text)
    {
        $("#"+this.GBName+"_foot").html(text);
    };
    
    this.addInBody = function(obj)
    {
        $("#"+this.GBName+"_body").append(obj);
    };
    
};


function HC_Tabs(pContainer)
{
    this.Tabs = [];
    this.TabsNames = [];
    this.Container = pContainer || "";
    this.isContainerGenerated = false;
    this.activeTabIndex = 0;
    
    this.Create = function()
    {
         var dv = $("<ul class='nav nav-tabs' id='" + this.Container + "_tab" + "'></ul>");
         $("#"+this.Container).append(dv);
         
         var dvcont = $("<div class='tab-content' id='" + this.Container + "_tabcontent" + "'></div>");
         $("#"+this.Container).append(dvcont);
         
         this.isContainerGenerated = true;
         
    };
    
    this.Dispose = function()
    {
         for(var i=0;i<this.Tabs.length;i++)
            this.Tabs[i].Dispose();
         
         this.Tabs = [];
         this.TabsNames = [];
        
         $("#" + this.Container + "_tab").remove();
         $("#" + this.Container + "_tabcontent").remove();
    };
    
    this.addTab = function(TabName,Title)
    {
        this.TabsNames.push(TabName);
        var tb = new HC_Tab(TabName,this.Container);
        if(this.Tabs.length===0)
            tb.Create(Title,true);
        else
            tb.Create(Title,false);
        this.Tabs.push(tb);
        return this.TabsNames.length - 1;
    };
    
    this.removeTabName = function(TabName)
    {
        var idx = this.TabsName.indexOf(TabName);
        this.Tabs[idx].Dispose();
    };
    
    this.removeTab = function(idx)
    {
        this.Tabs[idx].Dispose();
    };
    
    this.setTitle = function(idx,title)
    {
        this.Tabs[idx].setTitle(title);
    };
    
    this.addInBody = function(idx,obj)
    {
        this.Tabs[idx].addInBody(obj);
    };
    
    this.isTabExists = function(TabName)
    {
        //TabName = this.Container + "_" + TabName;
        if(this.TabsNames.indexOf(TabName)>=0)
            return true;
        else
            return false;
    };
    
    this.getTabIndex = function(TabName)
    {
        return this.TabsNames.indexOf(TabName);
    };
    
    this.setActive = function (idx)
    {
        this.Tabs[idx].setActive(idx);
        this.activeTabIndex = idx;
    };
    
    this.clearErrorClasses = function()
    {
        for(i=0;i<this.Tabs.length;i++)
            this.Tabs[i].setErrorClass(false);
    };
};


function HC_Tab(TBName,pContainer)
{
    this.TabName = pContainer + "_" + TBName || "";
    this.Container = pContainer || "";
    this.Rows = new HC_BSRows(this.TabName);
    
    this.Create = function(Title,firstTF)
    {
        var TabName = this.TabName;
        var tablink = null;
        var tabbody = null;
        if(firstTF)
        {
            tablink = $("<li id='" + TabName + "_link' class='nav-item active'><a class='nav-link' href='#" + TabName + "'>" + Title + "</a></li>");
            tabbody = $("<div id='" + TabName + "' class='container tab-pane active'><br /></div>");
        }
        else
        {
            tablink = $("<li id='" + TabName + "_link' class='nav-item'><a class='nav-link' href='#" + TabName + "'>" + Title + "</a></li>");
            tabbody = $("<div id='" + TabName + "' class='container tab-pane'><br /></div>");
        }
        $("#"+this.Container+"_tab").append(tablink);
        $("#"+this.Container+"_tabcontent").append(tabbody);
                
        $("#" + this.Container + "_tab a").click(function(){
            $(this).tab('show');
        });
        
    };
    
    this.Dispose = function()
    {
        this.Rows.Dispose();
        $("#"+this.TabName).remove();
        $("#"+this.TabName+"_link").remove();
        $("#" + this.Container + "_tab a").unbind("click");
        
    };
    
    this.setTitle = function(title)
    {
        $("#" + this.TabName + "_link a").html(title);
    };
    
    this.addInBody = function(obj)
    {
        $("#" + this.TabName).append(obj);
    };
    
    this.setErrorClass = function(tf)
    {
        if(tf)
        {
            $("#" + this.TabName + "_link").addClass("HC_TabError");
        }
        else{
            $("#" + this.TabName + "_link").removeClass("HC_TabError");
        }
    };
    
    this.setActive = function ()
    {
        $("#"+this.TabName+"_link a").click();
    };
};

function HC_BSRows(pContainer)
{
    this.BSRows = [];
    this.Container = pContainer || "";
    
    this.Create = function(RowName)
    {
        RowName = this.Container + "_" + RowName;
        this.BSRows.push(RowName);
        
        var row = $("<div id='" + RowName + "' class='row no-gutter'></div>");
        $("#"+this.Container).append(row);
        
        return this.BSRows.length - 1;
    };
    
    this.Dispose = function()
    {
        for(var i=0;i<this.BSRows.length;i++)
        {
            var RowName = this.Container + "_" + this.BSRows[i];
            $("#"+RowName).remove();
        }
        this.BSRows = [];
    };
    
    this.removeRow = function(RowName)
    {
        RowName = this.Container + "_" + RowName;
        this.BSRows.remove(RowName);
        $("#"+RowName).remove();
    };
    
    this.isRowExists = function(RowName)
    {
        RowName = this.Container + "_" + RowName;
        if(this.BSRows.indexOf(RowName)>=0)
            return true;
        else
            return false;
    };
    
    this.getRowIndex = function(RowName)
    {
        RowName = this.Container + "_" + RowName;
        return this.BSRows.indexOf(RowName);
    };
    
};

function HC_BSModal(pModalName,pParentClassV)
{
    this.ModalName = pModalName || "";
    this.Container = "";
    this.ModalType = "S";               //S Small, L Large
    this.ParentClassV = pParentClassV || null;
    
    this.generateModel = function(pContainer,ObjTF)
    {
        if(ObjTF)
        {
           this.Container = "";
        }
        else
        {
           this.Container = pContainer;
        }
        
        var id = this.getID();
        
        if($("#"+id).length===0)
        {
            var modal = "<div class='modal' id='" + id + "' role='dialog' data-keyboard='false' data-backdrop='static'>";

            var mdtp = "";
            if(this.ModalType==="XL")
                mdtp = "modal-xl";
            else
            if(this.ModalType==="L")
                mdtp = "modal-lg";
            else
                mdtp = "modal-sm";

                modal += "<div class='modal-dialog modal-dialog-centered " + mdtp + "'>";
                    modal += "<div class='modal-content'>";
                        modal += "<div class='modal-header' id='" + id + "_header'>";
                            modal += "<h5 id='" + id + "_title' class='modal-title'></h5>";
                            modal += "<button type='button' id='"+id+"_btnClose' class='close' data-dismiss='modal'>&times;</button>";
                        modal += "</div>";

                    modal += "<div class='modal-body' id='" + id +  "_body'></div>";

                        modal += "<div class='modal-footer' id='" + id + "_footer'>";
                            modal += "<button type='button' id='"+id+"_btnOK' class='btn btn-info btn-sm' data-dismiss='modal'>OK</button>";
                        modal += "</div>";    

                    modal += "</div>";

            modal += "</div>";

        modal += "</div>";

        if(ObjTF)
            pContainer.append(modal);
        else
            $("#"+pContainer).append(modal);
        }
        
        var parent = this;
        $("#"+id+"_btnOK").unbind("click");
        $("#"+id+"_btnOK").click(function(){

             try{
                parent.ParentClassV.ModalClose();
            }catch(e){}  

            try{
                parent.ParentClassV.btnOKClick();
            }catch(e){} 

            try{
            window[parent.ModalName+"_ModalClose"]();
            }catch(e){}

        });
        $("#"+id+"_btnClose").unbind("click");
        $("#"+id+"_btnClose").click(function(){

            try{
                parent.ParentClassV.ModalClose();
            }catch(e){} 

            try{
                parent.ParentClassV.btnCloseClick();
            }catch(e){} 

            try{
            window[id+"_ModalClose"]();
            }catch(e){}

        });
    
    };
    
    this.Create = function(pContainer)
    {
        this.generateModel(pContainer,false);
    };
    
    this.CreateJQObject = function(pContainer,pModalName)
    {
        this.ModalName = pModalName || this.ModalName;
        this.generateModel(pContainer,true);
    };
    
    this.getID = function()
    {
        if(this.Container!=="")
            return this.Container + "_" + this.ModalName;
        else
            return this.ModalName;
    };
    
    this.Dispose = function()
    {
        var id = this.getID();
        
        $("#"+id+"_title").remove();
        $("#"+id+"_body").remove();
        
        $("#"+id+"_btnOK").unbind("click");
        $("#"+id+"_btnOK").remove();
        
        $("#"+id+"_btnClose").unbind("click");
        $("#"+id+"_btnClose").remove();
        
        $("#"+id).remove();
    };
    
    this.AssignHTML = function(html)
    {
        $("#"+this.getID()+"_body").html(html);
    };
    
    this.OpenModal = function()
    {
        var id = this.getID();
        $("#"+id).modal("show");
        
        try{
            this.ParentClassV.ModalOpen();
        }catch(e){} 

        try{
        window[id+"_ModalOpen"]();
        }catch(e){}
    };
    
    this.CloseModal = function()
    {
        var id = this.getID();
        $("#"+id).modal("hide");
        
        try{
            this.ParentClassV.ModalClose();
        }catch(e){} 
        
        try{
        window[id+"_ModalClose"]();
        }catch(e){}
    };
    
    this.ShowHeader = function(tf)
    {
        var id = this.getID();
        if(tf)
            $("#"+id+"_header").show();
        else
            $("#"+id+"_header").hide();
    };
    
    this.ShowFooter = function(tf)
    {
        var id = this.getID();
        if(tf)
            $("#"+id+"_footer").show();
        else
            $("#"+id+"_footer").hide();
    };
};

function HC_Sleep(tmng)
{
    this.Timming = tmng || 3;
    this.DelayCall = function(SuccessfunC)
    {
        var aj = new HC_Ajax("Sleep");
        aj.addFormData("tmng",this.Timming);
        aj.CallServer(function(data){
            SuccessfunC(data);
        });
    };
}

function HC_Ajax(pAjaxID,pAjaxPage,pParentClassV,pFormName)
{
    this.AjaxID = pAjaxID || "";
    //this.AjaxPage = pAjaxPage || "https://localhost:7094/DB/Index";
    this.AjaxPage = pAjaxPage || "https://localhost:7094/DB/Index";
    this.CMN_WhereCL = "";
    this.CMN_WhereData = "";
    this.FormName = pFormName || "";
    this.WhereCLs = [];
    this.FormData = [];
    this.Addl = [];
    this.TranData = [];
    this.TranData1 = [];
    this.TranData2 = [];
    this.TranData3 = [];
    this.ParentClassV = pParentClassV || null;
    this.returnFunction = null;
    this.json = {"AjaxID":null,"FormName":null,"CMN_WhereCL":null,"CMN_WhereData":null,"WhereCLs":null,"FormData":null,"Addl":null,"TranData":null,"TranData1":null,"TranData2":null,"TranData3":null};
    this.addWhereClause = function(key,value){
        var wc = JSON.parse("{\"key\":\"" + key + "\",\"value\":\"\"}");
        wc.value = value;
        this.WhereCLs.push(wc);
    };
    this.addFormData = function(key,text,value){
        var fd;
        try{
            fd = JSON.parse("{\"key\":\"" + key + "\",\"text\":\"" + text + "\",\"value\":\"" + value + "\"}");
        }catch(e){
            var fd = JSON.parse("{\"key\":\"" + key + "\",\"text\":\"\",\"value\":\"\"}");
            fd.text = text;
            fd.value = value;
        };
        this.FormData.push(fd);
        //
    };
    this.addAdditional = function(key,value){
        var adl = JSON.parse("{\"key\":\"" + key + "\",\"value\":\"\"}");
        adl.value = value;
        this.Addl.push(adl);
    };
    
    this.addTransactionData = function(tdata)
    {
        this.TranData = tdata;
    };
    
    this.addTransactionData_1 = function(tdata)
    {
        this.TranData1 = tdata;
    };
    
    this.addTransactionData_2 = function(tdata)
    {
        this.TranData2 = tdata;
    };
    
    this.addTransactionData_3 = function(tdata)
    {
        this.TranData3 = tdata;
    };
    
    this.clearFormData = function()
    {
        this.FormData = [];
    };
    
    this.clearAdditional = function()
    {
        this.Addl = [];
    };
    
    this.clearWhereClause = function()
    {
        this.WhereCLs = [];
    };
    
    this.clearTransactionData = function()
    {
        this.TranData = [];
    };
    
    this.Assign = function()
    {
        this.json.AjaxID = this.AjaxID;
        this.json.FormName = this.FormName;
        this.json.CMN_WhereCL = this.CMN_WhereCL;
        this.json.CMN_WhereData = this.CMN_WhereData;
        this.json.FormData = this.FormData;
        this.json.WhereCLs = this.WhereCLs;
        this.json.Addl = this.Addl;
        this.json.TranData = this.TranData;
        this.json.TranData1 = this.TranData1;
        this.json.TranData2 = this.TranData2;
        this.json.TranData3= this.TranData3;

    };
    
    this.CallServer = function (SuccessfunC) {
        this.SyncAddlData();
        this.Assign();
        var sndJSON = JSON.stringify(this.json);
        //alert(sndJSON);
        $.ajax({
            "url": "https://localhost:7094/DB/Index",
            "method": "POST",
            "timeout": 0,
            "headers": {
                "Content-Type": "application/json"
            },
            "data": 
                sndJSON
            ,
            success: function (data) { 
              
                SuccessfunC(JSON.stringify(data));
        } 
        });
    };
    
    
    this.SyncAddlData = function()
    {
        this.clearAdditional();
        for (var x in GP){
            this.addAdditional(x,GP[x]);
        }
    };
    
};

function HC_Json(pjson)
{
    this.json = JSON.parse(pjson);
    
    this.AssignJSON = function(pjson)
    {
        this.json = pjson;
    };
    
    this.getVI = function(i)
    {
        var key = this.getKFI(i);
        return this.json[key];
    };
    
    this.getKFI = function(idx)
    {
        var i=0;
        for (var x in this.json){
            if(i===idx)
                return x;
            i++;
        }
        return "";
    };
    
    this.getVK = function(key)
    {
        if(this.getIFK(key)>=0)
            return this.json[key];
        else
            return "";
    };
    
    this.getIFK = function(key){
        var i=0;
        for (var x in this.json){
            if(x===key)
                return i;
            i++;
        }
        return -1;
    };
    
    this.getLength = function(){
        var i=0;
        for (var x in this.json){
            i++;
        }
        return i;
    };
    
    this.getArVI = function(i,j)
    {
        var key = this.getArKFI(j);
        return this.json[i][key];
    };
    
    this.getArKFI = function(idx)
    {
        var i=0;
        var json = this.json[0];
        for (var x in json){
            if(i===idx)
                return x;
            i++;
        }
        return "";
    };
    
    this.getArVK = function(i,key)
    {
        if(this.getArIFK(key)>=0)
            return this.json[i][key];
        else
            return "";
    };
    
    this.getArIFK = function(key){
        var i=0;
        for (var x in this.json[0]){
            if(x===key)
                return i;
            i++;
        }
        return -1;
    };
    
    
    this.getArColumnLength = function(){
        var i=0;
        for (var x in this.json[0]){
            i++;
        }
        return i;
    };
    
    this.getArRowLength = function(){
        return this.json.length;
    };
};



function checkVTP(data,vtp)
{
    var patt,msg;
    if(vtp==="IP" || vtp==="UID" || vtp==="PAN" || vtp==="DT" || vtp==="ND" || vtp==="NF" || vtp==="D" || vtp==="F" || vtp==="M" || vtp==="L" || vtp==="E" || vtp==="W" || vtp==="C")
    {
        if(vtp==="ND"){
            patt = /^[-]?\d+$/;
            msg = "only numbers are allowed";
        }
        if(vtp==="D"){
            patt = /^\d+$/;
            msg = "only numbers are allowed";
        }
        if(vtp==="F"){
            patt = /^((\.\d+)|(\d+(\.\d+)?))$/;
            msg = "only number with dot (.)";
        }
        if(vtp==="NF"){
            patt = /^[-]?((\.\d+)|(\d+(\.\d+)?))$/;
            msg = "only number with dot (.)";
        }
        if(vtp==="M"){
            patt = /^\d{10}$/;
            msg = "only mobile number format 10 digits";
        }
        if(vtp==="L"){
            patt = /^\d{9}|\d{10}|\d{11}|\d{12}|\d{13}$/;
            msg = "only number with dash (-)";
        }
        if(vtp==="DT"){
            patt = /^(0?[1-9]|[12][0-9]|3[01])[\-](0?[1-9]|1[012])[\-]\d{4}$/;
            msg = "only date format (dd-mm-yyyy)";
        }
        if(vtp==="PAN"){
            patt = /^([a-zA-Z]{5})(\d{4})([a-zA-Z]{1})$/;
            msg = "only pan card format (AAAAA9999A)";
        }
        if(vtp==="UID"){
            patt = /^(\d{4})\-(\d{4})\-(\d{4})$/;
            msg = "only UID (Aadhar) card format (0000-0000-0000)";
        }
        if(vtp==="C"){
            patt = /^\d{6}$/;
            msg = "only pincode format 6 digits (000000)";
        }
        if(vtp==="E"){
            patt = /^\b[A-Z0-9._%-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b$/i;
            msg = "only email format (xxx@xxx.xxx)";
        }
        if(vtp==="W"){
            patt = /^(http|https)?:\/\/[a-zA-Z0-9-\.]+\.[a-z]{2,4}/;
            msg = "only webmail format (http://www.xxx.com)";
        }
        if(vtp==="IP"){
            patt = /^(\d|[1-9]\d|1\d\d|2([0-4]\d|5[0-5]))\.(\d|[1-9]\d|1\d\d|2([0-4]\d|5[0-5]))\.(\d|[1-9]\d|1\d\d|2([0-4]\d|5[0-5]))\.(\d|[1-9]\d|1\d\d|2([0-4]\d|5[0-5]))$/;
            msg = "only IP Address format (000.000.000.000)";
        }
    }
    
    if(patt.test(data))
        return msg;
    else
        return "";
}

function HC_Timer()
{
    this.Interval = null;
    this.Function = null;
    this.tmid = null;
    this.Status = "";
    
    this.setNewTiming = function(Interval,Function)
    {
        this.Interval = Interval;
        this.Function = Function;
    };
    
    this.setNewTimingAndStart = function(Interval,Function)
    {
        this.Interval = Interval;
        this.Function = Function;
        this.Start();
    };
    
    this.setFunction = function(Function)
    {
        this.Function = Function;
        this.RefreshInterval();
    };
    
    this.setInterval = function(Interval)
    {
        this.Interval = Interval;
        this.RefreshInterval();
    };
    
    this.RefreshInterval = function()
    {
        if(this.Status==="Start"){
            this.Stop();
            this.tmid = setInterval(this.Interval,this.Function);
        }
    };
    
    this.Start = function()
    {
        this.Status = "Start";
        this.RefreshInterval();
    };
    
    this.Stop = function()
    {
        this.Status = "Stop";
        clearInterval(this.tmid);
    };
    
    this.Resume = function()
    {
        this.Start();
    };
    
    this.CallAfter = function(Function,Interval)
    {
        var parent = this;
        this.tmid = setInterval(function() {
            Function();
            clearInterval(parent.tmid);
        },Interval);
    };
    
};


function HC_DelayCall(tm)
{
    this.timming = tm || "";
    this.Call = function(Function,Interval)
    {
        this.timming = Interval || "";
        var aj = new HC_Ajax("Sleep");
        aj.addFormData("tmng",this.timming,this.timming);
        aj.CallServer(Function);
    };
    
};



function HC_ProgressBar()
{
    this.Modal = new HC_BSModal("mdpbar");
    this.Modal.ModalType = "L";
    this.openProgress = function(){
        $("#dvpbar").html("");
        this.Modal.generateModel("dvpbar");
        this.Modal.ShowFooter(false);
        this.Modal.ShowHeader(false);
        this.Modal.AssignHTML("<img src='~/image/loadimg2.gif' style='display: block;margin-left: auto;margin-right: auto;width: 80%;' />");
        this.Modal.OpenModal();
    };
    this.closeProgess = function(){
        this.Modal.CloseModal();
        this.Modal.Dispose();
    };
}





function HC_BSModal(pModalName,pParentClassV)
{
    this.ModalName = pModalName || "";
    this.Container = "";
    this.ModalType = "S";               //S Small, L Large
    this.ParentClassV = pParentClassV || null;
    
    this.generateModel = function(pContainer,ObjTF)
    {
        if(ObjTF)
        {
           this.Container = "";
        }
        else
        {
           this.Container = pContainer;
        }
        
        var id = this.getID();
        
        if($("#"+id).length===0)
        {
            var modal = "<div class='modal' id='" + id + "' role='dialog' data-keyboard='false' data-backdrop='static'>";

            var mdtp = "";
            if(this.ModalType==="XL")
                mdtp = "modal-xl";
            else
            if(this.ModalType==="L")
                mdtp = "modal-lg";
            else
                mdtp = "modal-sm";

                modal += "<div class='modal-dialog modal-dialog-centered " + mdtp + "'>";
                    modal += "<div class='modal-content'>";
                        modal += "<div class='modal-header' id='" + id + "_header'>";
                            modal += "<h5 id='" + id + "_title' class='modal-title'></h5>";
                            modal += "<button type='button' id='"+id+"_btnClose' class='close' data-dismiss='modal'>&times;</button>";
                        modal += "</div>";

                    modal += "<div class='modal-body' id='" + id +  "_body'></div>";

                        modal += "<div class='modal-footer' id='" + id + "_footer'>";
                            modal += "<button type='button' id='"+id+"_btnOK' class='btn btn-info btn-sm' data-dismiss='modal'>Close</button>";
                        modal += "</div>";    

                    modal += "</div>";

            modal += "</div>";

        modal += "</div>";

        if(ObjTF)
            pContainer.append(modal);
        else
            $("#"+pContainer).append(modal);
        }
        
        var parent = this;
        $("#"+id+"_btnOK").unbind("click");
        $("#"+id+"_btnOK").click(function(){

             try{
                parent.ParentClassV.ModalClose();
            }catch(e){}  

            try{
                parent.ParentClassV.btnOKClick();
            }catch(e){} 

            try{
            window[parent.ge+"_ModalClose"]();
            }catch(e){}

        });
        $("#"+id+"_btnClose").unbind("click");
        $("#"+id+"_btnClose").click(function(){

            try{
                parent.ParentClassV.ModalClose();
            }catch(e){} 

            try{
                parent.ParentClassV.btnCloseClick();
            }catch(e){} 

            try{
            window[id+"_ModalClose"]();
            }catch(e){}

        });
    
    };
    
    this.Create = function(pContainer)
    {
        this.generateModel(pContainer,false);
    };
    
    this.CreateJQObject = function(pContainer,pModalName)
    {
        this.ModalName = pModalName || this.ModalName;
        this.generateModel(pContainer,true);
    };
    
    this.getID = function()
    {
        if(this.Container!=="")
            return this.Container + "_" + this.ModalName;
        else
            return this.ModalName;
    };
    
    this.Dispose = function()
    {
        var id = this.getID();
        
        $("#"+id+"_title").remove();
        $("#"+id+"_body").remove();
        
        $("#"+id+"_btnOK").unbind("click");
        $("#"+id+"_btnOK").remove();
        
        $("#"+id+"_btnClose").unbind("click");
        $("#"+id+"_btnClose").remove();
        
        $("#"+id).remove();
    };
    
    this.AssignHTML = function(html)
    {
        $("#"+this.getID()+"_body").html(html);
    };
    
    this.OpenModal = function()
    {
        var id = this.getID();
        $("#"+id).modal("show");
        
        try{
            this.ParentClassV.ModalOpen();
        }catch(e){} 

        try{
        window[id+"_ModalOpen"]();
        }catch(e){}
    };
    
    this.CloseModal = function()
    {
        var id = this.getID();
        $("#"+id).modal("hide");
        
        try{
            this.ParentClassV.ModalClose();
        }catch(e){} 
        
        try{
        window[id+"_ModalClose"]();
        }catch(e){}
    };
    
    this.ShowHeader = function(tf)
    {
        var id = this.getID();
        if(tf)
            $("#"+id+"_header").show();
        else
            $("#"+id+"_header").hide();
    };
    
    this.ShowFooter = function(tf)
    {
        var id = this.getID();
        if(tf)
            $("#"+id+"_footer").show();
        else
            $("#"+id+"_footer").hide();
    };
};


function HC_SideMenu(pSideMenu,pParentClassV)
{
    this.SideMenu = pSideMenu || "";
    this.Container = "";
    this.ParentClassV = pParentClassV || null;
    this.TextBox = new HC_TextBox(pSideMenu+"_SearchText");
    this.ButtonGroup = new HC_ButtonGroup(pSideMenu+"_ButtonGRP");
    this.DDMenus = [];
    this.DDMenusName = [];
    this.LinkMenus = [];
    this.LinkMenusName = [];
    this.menuJSON = null;
    this.currMenuNM = null;
    
    this.getID = function()
    {
        if(this.Container!=="")
            return this.Container + "_" + this.CTLName;
        else
            return this.CTLName;
    };
    
    this.generateSideMenu = function(pContainer,ObjTF)
    {
        if(ObjTF)
        {
           this.Container = "";
        }
        else
        {
           this.Container = pContainer;
        }
        
        var id = this.getID();
        
        if($("#"+id).length===0)
        {
            var parent = this;
            var modal = "<div style='height: 35px' id='" + id + "_search_div'></div>";
                
                modal += "<div style='margin-top: -2px;margin-bottom:3px' id='" + id + "_menu_button'></div>";
                modal += "<div style='overflow-y: scroll;width:15rem' id='" + id + "_menu_div'> <div id='" + id + "'></div></div>";
                
            
            if(ObjTF)
                pContainer.append(modal);
            else
                $("#"+pContainer).append(modal);
            
            this.TextBox.generateControlJQObject($("#"+id+"_search_div"));
            $("#"+id+"_menu_button").append("<a href='#' id='" + id + "_menu_expand' style='text-decoration: none;'>&nbsp;&nbsp;<img src='img/expand.png' style='height:20px;width:20px' /> Expand All </a>");
            $("#"+id+"_menu_button").append("<a href='#' id='" + id + "_menu_close' style='text-decoration: none;'>&nbsp;&nbsp;<img src='img/collapse.png' style='height:20px;width:20px' /> Collapse All</a>");
            //alert($("#"+id+"_SearchText").length);
            $("#"+id+"_SearchText").keyup(function(e){
                parent.searchLink($("#"+id+"_SearchText").val());
            });
            
            $("#"+id+"_menu_expand").click(function(){
                parent.expandAll();
            });

            $("#"+id+"_menu_close").click(function(){
                parent.closeAll();
            });
            
            $("#" + id + "_menu_div").css("height",$(window).height()-116);
            
        }
    };
    
    this.Create = function(pContainer)
    {
        this.generateSideMenu(pContainer,false);
    };
    
    this.CreateJQObject = function(pContainer,pModalName)
    {
        this.SideMenu = pModalName || this.SideMenu;
        this.generateSideMenu(pContainer,true);
    };
    
    this.getID = function()
    {
        if(this.Container!=="")
            return this.Container + "_" + this.SideMenu;
        else
            return this.SideMenu;
    };
    
    this.Dispose = function()
    {
        var id = this.getID();
        $("#"+id).remove();
    };
    
    
    this.addDDMenu = function(pDDSideMenu,pLabel)
    {
        var dd = new HC_DropDownSideMenu(pDDSideMenu,pLabel,null);
        dd.Create(this.getID() + "_menu_div");
        this.DDMenus.push(dd);
        this.DDMenusName.push(pDDSideMenu);
    };
    
    this.addLinkMenu = function(pLinkSideMenu,pLabel,pLink)
    {
        var dd = new HC_LinkSideMenu(pLinkSideMenu,pLabel,pLink,null);
        dd.CreateJQObject($("#" + this.getID() + "_menu_div"));
        this.LinkMenus.push(dd);
        this.LinkMenusName.push(pLinkSideMenu);
    };
    
    this.createMenus = function(p_mnuJSON){
        
        this.DDMenus = [];
        this.DDMenusName = [];
        this.LinkMenus = [];
        this.LinkMenusName = [];
        
        this.menuJSON = p_mnuJSON || this.menuJSON;
        var i,j,k;
        $("#" + this.getID() + "_menu_div").html("");
        for(i=0;i<this.menuJSON.length;i++)
        {
            if(this.menuJSON[i].submenu===undefined){
                this.addLinkMenu(this.menuJSON[i].nm,this.menuJSON[i].menu,this.menuJSON[i].link); //Add Link Menu
            }
            else{
                this.addDDMenu(this.menuJSON[i].nm,this.menuJSON[i].menu);  //Add DD Menu
                for(j=0;j<this.menuJSON[i].submenu.length;j++){
                    if(this.menuJSON[i].submenu[j].submenu===undefined){
                        this.DDMenus[i].addSubLinkMenu(this.menuJSON[i].submenu[j].nm,this.menuJSON[i].submenu[j].menu,this.menuJSON[i].submenu[j].link);
                    }
                    else{
                        this.DDMenus[i].addSubDDMenu(this.menuJSON[i].submenu[j].nm,this.menuJSON[i].submenu[j].menu);
                        for(k=0;k<this.menuJSON[i].submenu[j].submenu.length;k++){
                            this.DDMenus[i].SubDDMenus[j].addSubLinkMenu(this.menuJSON[i].submenu[j].submenu[k].nm,this.menuJSON[i].submenu[j].submenu[k].menu,this.menuJSON[i].submenu[j].submenu[k].link);
                        }
                    }
                }
            }
        }
    };
    
    this.setInActiveAll = function(){
        var i;
        for(i=0;i<this.LinkMenus.length;i++)
        {
            this.LinkMenus[i].setActive(false);
        }
        
        for(i=0;i<this.DDMenus.length;i++)
        {
            this.DDMenus[i].setInActiveAll();
        }
    };
    
    this.getLinkMenu = function(pMenuName){
        var i;
        for(i=0;i<this.LinkMenus.length;i++)
        {
            if(pMenuName===this.LinkMenus[i].LinkSideMenu)
                return this.LinkMenus[i];
                //this.LinkMenus[i].setActive(false);
        }
        
        for(i=0;i<this.DDMenus.length;i++)
        {
            var mn = this.DDMenus[i].getLinkMenu(pMenuName);
            if(mn!==null)
                return mn;
        }
        
        return null;
    };
    
    this.searchLink = function(pMenuName){
        if(pMenuName!=="")
        {
            $("#" + this.getID() + "_menu_div").html("");
            var i,j,k;
            var srt = pMenuName.toLowerCase();
            for(i=0;i<this.menuJSON.length;i++)
            {
                if(this.menuJSON[i].submenu===undefined){
                    if(this.menuJSON[i].menu.toLowerCase().indexOf(srt)>=0){
                        this.addLinkMenu(this.menuJSON[i].nm,this.menuJSON[i].menu,this.menuJSON[i].link); //Add Link Menu
                    }
                }
                else{
                    //this.addDDMenu(this.menuJSON[i].nm,this.menuJSON[i].menu);  //Add DD Menu
                    for(j=0;j<this.menuJSON[i].submenu.length;j++){
                        if(this.menuJSON[i].submenu[j].submenu===undefined){
                            if(this.menuJSON[i].submenu[j].menu.toLowerCase().indexOf(srt)>=0){
                                this.addLinkMenu(this.menuJSON[i].submenu[j].nm,this.menuJSON[i].submenu[j].menu,this.menuJSON[i].submenu[j].link);
                            }
                        }
                        else{
                            //this.DDMenus[i].addSubDDMenu(this.menuJSON[i].submenu[j].nm,this.menuJSON[i].submenu[j].menu);
                            for(k=0;k<this.menuJSON[i].submenu[j].submenu.length;k++){
                                if(this.menuJSON[i].submenu[j].submenu[k].menu.toLowerCase().indexOf(srt)>=0)
                                    this.addLinkMenu(this.menuJSON[i].submenu[j].submenu[k].nm,this.menuJSON[i].submenu[j].submenu[k].menu,this.menuJSON[i].submenu[j].submenu[k].link);
                            }
                        }
                    }
                }
            }
        }
        else
            this.createMenus();
    };
    
    this.OpenLink = function(pMenuNM,pContainer)
    {
        var LinkMenu;
        if(this.currMenuNM!==pMenuNM){
            try{
                this.setInActiveAll();
                this.createMenus();
                this.closeAll();
                LinkMenu = this.getLinkMenu(pMenuNM);
                $("#"+pContainer).html("");
                $.ajax({url: LinkMenu.Link,
                success : function(data) {
                    $("#"+pContainer).html(data);
                } 
                });
                LinkMenu.setActive(true);
                
                if(LinkMenu.ParentClassV!==null){
                    LinkMenu.ParentClassV.expandAll();
                    if(LinkMenu.ParentClassV.ParentClassV!==null){
                        LinkMenu.ParentClassV.ParentClassV.expandAll();
                    }
                }
                this.currMenu = LinkMenu;
            }catch(e){alert(e);}
        }
    };
    
    this.expandAll = function(){
        var i;
        for(i=0;i<this.DDMenus.length;i++)
        {
            this.DDMenus[i].expandAll();
        }
    };
    
    this.closeAll = function(){
        var i;
        for(i=0;i<this.DDMenus.length;i++)
        {
            this.DDMenus[i].closeAll();
        }
    };
};

function HC_DropDownSideMenu(pDDSideMenu,pLabel,pParentClassV)
{
    this.DDSideMenu = pDDSideMenu || "";
    this.Container = "";
    this.ParentClassV = pParentClassV || null;
    this.Label = pLabel || "";
    this.SubDDMenus = [];
    this.SubDDMenusName = [];
    this.SubLinkMenus = [];
    this.SubLinkMenusName = [];
    this.expandAll = function(){
        var i;
        if(!$("#"+this.getID()+"_SubMenuLink").hasClass("isMenuOpen")){
            $("#"+this.getID()+"_SubMenuLink").click();
        }
        for(i=0;i<this.SubDDMenus.length;i++)
        {
        this.SubDDMenus[i].expandAll();
        }
    };
    
    this.closeAll = function(){
        var i;
        if($("#"+this.getID()+"_SubMenuLink").hasClass("isMenuOpen")){
            $("#"+this.getID()+"_SubMenuLink").click();
        }
        for(i=0;i<this.SubDDMenus.length;i++)
        {
        this.SubDDMenus[i].closeAll();
        }
    };
    
    this.addSubDDMenu = function(pDDSideMenu,pLabel)
    {
        var dd = new HC_DropDownSideMenu(pDDSideMenu,pLabel,this);
        dd.Create(this.getID()+"_SubMenu");
        this.SubDDMenus.push(dd);
        this.SubDDMenusName.push(pDDSideMenu);
    };
    
    this.addSubLinkMenu = function(pLinkSideMenu,pLabel,pLink)
    {
        var dd = new HC_LinkSideMenu(pLinkSideMenu,pLabel,pLink,this);
        dd.Create(this.getID()+"_SubMenu");
        this.SubLinkMenus.push(dd);
        this.SubLinkMenusName.push(pLinkSideMenu);
    };
    
    this.generateDDSideMenu = function(pContainer,ObjTF)
    {
        if(ObjTF)
        {
           this.Container = "";
        }
        else
        {
           this.Container = pContainer;
        }
        
        var id = this.getID();
        
        if($("#"+id).length===0)
        {
            var modal = "<div id='" + id + "' class='list-group'>";
                modal +="<a href='#" + id + "_SubMenu' id='" + id + "_SubMenuLink' data-toggle='collapse' aria-expanded='false' style='background-color: #AAAAAA;color: #ffffff;' class='dropdown-toggle list-group-item list-group-item-action'>" + this.Label + "</a>";
                modal +="<div class='collapse list-unstyled' id='" + id + "_SubMenu'></div>";
            modal += "</div>";

            if(ObjTF)
                pContainer.append(modal);
            else
                $("#"+pContainer).append(modal);
            
            $("#" + id + "_SubMenuLink").click(function(){
                if(!$(this).hasClass("isMenuOpen")){
                    $(this).addClass("isMenuOpen");
                }
                else{
                    $(this).removeClass("isMenuOpen");
                }
            });
            
        }
    };
    
    this.Create = function(pContainer)
    {
        this.generateDDSideMenu(pContainer,false);
    };
    
    this.CreateJQObject = function(pContainer,pModalName)
    {
        this.DDSideMenu = pModalName || this.DDSideMenu;
        this.generateDDSideMenu(pContainer,true);
    };
    
    this.getID = function()
    {
        if(this.Container!=="")
            return this.Container + "_" + this.DDSideMenu;
        else
            return this.SideMenu;
    };
    
    this.Dispose = function()
    {
        var id = this.getID();
        $("#"+id).remove();
        $("#"+id).remove();
    };
    
    this.setLabel = function(pLabel){
        var id = this.getID();
        this.Label = pLabel;
        $("#"+id+"_SubMenu").html(pLabel);
    };
    
    this.setInActiveAll = function(){
        var i;
        for(i=0;i<this.SubLinkMenus.length;i++)
        {
            this.SubLinkMenus[i].setActive(false);
        }
        
        for(i=0;i<this.SubDDMenus.length;i++)
        {
            this.SubDDMenus[i].setInActiveAll();
        }
    };
    
    
    this.getLinkMenu = function(pMenuName){
        var i;
        for(i=0;i<this.SubLinkMenus.length;i++)
        {
            if(pMenuName===this.SubLinkMenus[i].LinkSideMenu)
                return this.SubLinkMenus[i];
                //this.LinkMenus[i].setActive(false);
        }
        
        for(i=0;i<this.SubDDMenus.length;i++)
        {
            var mn = this.SubDDMenus[i].getLinkMenu(pMenuName);
            if(mn!==null)
                return mn;
        }
        
        return null;
    };
};

function HC_LinkSideMenu(pLinkSideMenu,pLabel,pLink,pParentClassV)
{
    this.LinkSideMenu = pLinkSideMenu || "";
    this.Container = "";
    this.ParentClassV = pParentClassV || null;
    this.Link = pLink || "";
    this.Label = pLabel || "";
    this.Active = false;
    this.generateLinkSideMenu = function(pContainer,ObjTF)
    {
        if(ObjTF)
        {
           this.Container = "";
        }
        else
        {
           this.Container = pContainer;
        }
        
        var id = this.getID();
        
        if($("#"+id).length===0)
        {
            //var modal = "<a href='" + this.Link + "' id='" + id + "' class='list-group-item list-group-item-action bg-light' onlclick='OPage(\"" + this.Link + "\");'>";
            var modal = "<a href='" + this.Link + "' id='" + id + "' class=\"list-group-item list-group-item-action bg-light hc_sidemenuitem\" onclick='OPage(\"" + this.LinkSideMenu + "\");'>";
                modal += this.Label;
                modal +="</a>";
            
            if(ObjTF)
                pContainer.append(modal);
            else
                $("#"+pContainer).append(modal);
        }
    };
    
    this.Create = function(pContainer,pLink,pLabel)
    {
        this.generateLinkSideMenu(pContainer,false,pLink,pLabel);
    };
    
    this.CreateJQObject = function(pContainer,pModalName,pLink,pLabel)
    {
        this.LinkSideMenu = pModalName || this.LinkSideMenu;
        this.generateLinkSideMenu(pContainer,true,pLink,pLabel);
    };
    
    this.getID = function()
    {
        if(this.Container!=="")
            return this.Container + "_" + this.LinkSideMenu;
        else
            return this.LinkSideMenu;
    };
    
    this.Dispose = function()
    {
        var id = this.getID();
        $("#"+id).remove();
    };
    
    this.setLabel = function(pLabel){
        var id = this.getID();
        this.Label = pLabel;
        $("#"+id).html(pLabel);
    };
    
    this.setLink = function(pLink){
        var id = this.getID();
        this.Link = pLink;
        $("#"+id).prop("href",pLink);
    };
    
    this.setActive = function(tf){
        var id = this.getID();
        this.Active = tf;
        if(tf)
            $("#"+id).css("font-weight","bold");
        else
            $("#"+id).css("font-weight","normal");
    };
    
    this.isActive = function(){
        return this.Active;
    };
};

function getQueryString(s){
    var i,nm,vl;
    var url = window.location.href;
    var ar = url.slice(url.indexOf('?') + 1).split('&');
    for(i=0;i<ar.length;i++){
        nm = ar[i].split('=')[0];
        vl = ar[i].split('=')[1];
        if(nm===s)
            return vl;
    }
    return undefined;
}

function HC_TreeListView(pTreeView,pParentClassV)
{
    this.TreeList = pTreeView || "";
    this.Container = "";
    this.ParentClassV = pParentClassV || null;
    this.TextBox = new HC_TextBox(pTreeView + "_Search");
    this.DDGroupList = [];
    this.DDGroupListName = [];
    this.SingleList = [];
    this.SingleListName = [];
    this.TreeViewJSON = null;
    this.StartDate = "2021-08-01";
    this.EndDate = "2021-08-31";
    this.AjaxID = "";
    this.Ajax = new HC_Ajax();
    this.getID = function()
    {
        if(this.Container!=="")
            return this.Container + "_" + this.TreeList;
        else
            return this.TreeList;
    };
    
    this.generateTreeList = function(pContainer,ObjTF)
    {
        if(ObjTF)
        {
           this.Container = "";
        }
        else
        {
           this.Container = pContainer;
        }
        
        var id = this.getID();
        
        if($("#"+id).length===0)
        {
            var parent = this;
            var modal = "<div style='height: 35px' id='" + id + "_search_div'></div>";
                modal += "<div style='margin-top: 0px;margin-bottom:5px' id='" + id + "_treelist_button'></div>";
                
                modal += "<div style='overflow-y:scroll'>";
                modal += "<a href='#' class=\"list-group-item list-group-item-action bg-light hc_sidemenuitem\" style='height:33px;padding:5px'>";
                modal += "<div class='row no-gutter'>";
                modal += "<div class='col-sm-8'><b>Ledger / Group</b></div>";
                modal += "<div class='col-sm-1'><b>Opening</b></div>";
                modal += "<div class='col-sm-1'><b>Credit</b></div>";
                modal += "<div class='col-sm-1'><b>Debit</b></div>";
                modal += "<div class='col-sm-1'><b>Closing</b></div>";
                modal += "</div>";
                modal +="</a>";
                
                modal += "<a href='#' class=\"list-group-item list-group-item-action bg-light hc_sidemenuitem\" style='height:33px;padding:5px'>";
                modal += "<div class='row no-gutter'>";
                modal += "<div class='col-sm-8'></div>";
                modal += "<div class='col-sm-1' id='" + id + "_AllOP'></div>";
                modal += "<div class='col-sm-1' id='" + id + "_AllCR'></div>";
                modal += "<div class='col-sm-1' id='" + id + "_AllDR'></div>";
                modal += "<div class='col-sm-1' id='" + id + "_AllCL'></div>";
                modal += "</div>";
                modal +="</a>";
                
                modal += "</div>";
                
                modal += "<div style='overflow-y: scroll;' id='" + id + "_treelist_div'> <div id='" + id + "'></div></div>";
            
            if(ObjTF)
                pContainer.append(modal);
            else
                $("#"+pContainer).append(modal);
            
            this.TextBox.generateControlJQObject($("#"+id+"_search_div"));
            this.TextBox.setLabel("Search Accounts");
            $("#"+id+"_treelist_button").append("<a href='#' id='" + id + "_treelist_expand' style='text-decoration: none;'>&nbsp;&nbsp;<img src='img/expand.png' style='height:20px;width:20px' /> Expand All </a>");
            $("#"+id+"_treelist_button").append("<a href='#' id='" + id + "_treelist_close' style='text-decoration: none;'>&nbsp;&nbsp;<img src='img/collapse.png' style='height:20px;width:20px' /> Collapse All</a>");
            //alert($("#"+id+"_SearchText").length);
            $("#"+id+"_SearchText").keyup(function(e){
                parent.searchLink($("#"+id+"_SearchText").val());
            });
            
            $("#"+id+"_treelist_expand").click(function(){
                parent.expandAll();
            });

            $("#"+id+"_treelist_close").click(function(){
                parent.closeAll();
            });
            
            $("#" + id + "_treelist_div").css("height",$(window).height()-240);
            
        }
    };
    
    this.Create = function(pContainer)
    {
        this.generateTreeList(pContainer,false);
    };
    
    this.CreateJQObject = function(pContainer)
    {
        this.generateTreeList(pContainer,true);
    };
    
    this.Dispose = function()
    {
        var id = this.getID();
        $("#"+id).remove();
    };
    
    this.addDDGroupList = function(pJSON)
    {
        var dd = new HC_DropDownGroupList(pJSON,null);
        dd.Create(this.getID() + "_treelist_div");
        this.DDGroupList.push(dd);
        this.DDGroupListName.push(pJSON.id);
    };
    
    this.addSingleList = function(pJSON)
    {
        var dd = new HC_SingleList(pJSON,null);
        dd.CreateJQObject($("#" + this.getID() + "_treelist_div"));
        this.SingleList.push(dd);
        this.SingleList.push(pJSON.id);
    };
    
    this.createLists = function(p_mnuJSON){
        
        this.DDGroupList = [];
        this.DDGroupListName = [];
        this.SingleList = [];
        this.SingleListName = [];
        
        this.TreeViewJSON = p_mnuJSON || this.TreeViewJSON;
        
        var i,j,k;
        $("#" + this.getID() + "_treelist_div").html("");
        for(i=0;i<this.TreeViewJSON.length;i++)
        {
            if(this.TreeViewJSON[i].items.length===0){
                this.addSingleList(this.TreeViewJSON[i]); //Add Link Menu
            }
            else{
                this.addDDGroupList(this.TreeViewJSON[i]);  //Add DD Menu
                for(j=0;j<this.TreeViewJSON[i].items.length;j++){
                    if(this.TreeViewJSON[i].items[j].items.length===0){
                        this.DDGroupList[i].addSubSingleList(this.TreeViewJSON[i].items[j]);
                    }
                    else{
                        this.DDGroupList[i].addSubDDGroupList(this.TreeViewJSON[i].items[j]);
                        for(k=0;k<this.TreeViewJSON[i].items[j].items.length;k++){
                            this.DDGroupList[i].SubDDGroupList[j].addSubSingleList(this.TreeViewJSON[i].items[j].items[k]);
                        }
                    }
                }
            }
        }
    };
    
    this.setInActiveAll = function(){
        var i;
        for(i=0;i<this.LinkMenus.length;i++)
        {
            this.LinkMenus[i].setActive(false);
        }
        
        for(i=0;i<this.DDMenus.length;i++)
        {
            this.DDMenus[i].setInActiveAll();
        }
    };
    
    this.getLinkMenu = function(pMenuName){
        var i;
        for(i=0;i<this.LinkMenus.length;i++)
        {
            if(pMenuName===this.LinkMenus[i].LinkSideMenu)
                return this.LinkMenus[i];
                //this.LinkMenus[i].setActive(false);
        }
        
        for(i=0;i<this.DDMenus.length;i++)
        {
            var mn = this.DDMenus[i].getLinkMenu(pMenuName);
            if(mn!==null)
                return mn;
        }
        
        return null;
    };
    
    this.searchLink = function(pMenuName){
        if(pMenuName!=="")
        {
            $("#" + this.getID() + "_treelist_div").html("");
            var i,j,k;
            var srt = pMenuName.toLowerCase();
            for(i=0;i<this.menuJSON.length;i++)
            {
                if(this.menuJSON[i].submenu===[]){
                    if(this.menuJSON[i].menu.toLowerCase().indexOf(srt)>=0){
                        this.addLinkMenu(this.menuJSON[i].nm,this.menuJSON[i].menu,this.menuJSON[i].link); //Add Link Menu
                    }
                }
                else{
                    //this.addDDMenu(this.menuJSON[i].nm,this.menuJSON[i].menu);  //Add DD Menu
                    for(j=0;j<this.menuJSON[i].submenu.length;j++){
                        if(this.menuJSON[i].submenu[j].submenu===[]){
                            if(this.menuJSON[i].submenu[j].menu.toLowerCase().indexOf(srt)>=0){
                                this.addLinkMenu(this.menuJSON[i].submenu[j].nm,this.menuJSON[i].submenu[j].menu,this.menuJSON[i].submenu[j].link);
                            }
                        }
                        else{
                            //this.DDMenus[i].addSubDDMenu(this.menuJSON[i].submenu[j].nm,this.menuJSON[i].submenu[j].menu);
                            for(k=0;k<this.menuJSON[i].submenu[j].submenu.length;k++){
                                if(this.menuJSON[i].submenu[j].submenu[k].menu.toLowerCase().indexOf(srt)>=0)
                                    this.addLinkMenu(this.menuJSON[i].submenu[j].submenu[k].nm,this.menuJSON[i].submenu[j].submenu[k].menu,this.menuJSON[i].submenu[j].submenu[k].link);
                            }
                        }
                    }
                }
            }
        }
        else
            this.createMenus();
    };
    
    this.GetDataServer = function(pStartDate,pEndDate,pAjaxID)
    {
        this.StartDate = pStartDate || this.StartDate;
        this.EndDate = pEndDate || this.EndDate;
        this.AjaxID = pAjaxID || this.AjaxID;
        this.Ajax.AjaxID = this.AjaxID;
        
        this.Ajax.addFormData("stdt",this.StartDate);
        this.Ajax.addFormData("endt",this.EndDate);
        
        var parent = this;
        this.Ajax.CallServer(function(data){
            try{
            parent.convertDatatoJSON(data);
            }catch(e){alert(e);}
            parent.createLists();
        });
    };
    
    this.convertDatatoJSON = function(data){
      
        var js = JSON.parse(data);
        var rString = "{\"id\":\"\",\"ledger\":\"\",\"op\":\"\",\"cr\":\"\",\"dr\":\"\",\"cl\":\"\",\"items\":[]}";
        this.TreeViewJSON = [];
        var mGroup = "",sGroup = "";
        var mRow,sRow,Row;
        var id = this.getID();
        var i;
        if(js.length>0){
            
            mGroup = js[0].bgid;
            sGroup = js[0].lgpid;
            mRow = JSON.parse(rString);
            this.assignRowData(mRow,js[0],"M",js);
            sRow = JSON.parse(rString);
            this.assignRowData(sRow,js[0],"S",js);
            Row = JSON.parse(rString);
            this.assignRowData(Row,js[0]);
            if(js[0].bgid==="0"){
                sRow.items.push(Row);
                this.TreeViewJSON.push(sRow);
            }
            else{
                sRow.items.push(Row);
                mRow.items.push(sRow);
                this.TreeViewJSON.push(mRow);
            }
            
            for(i=1;i<js.length;i++){
                Row = JSON.parse(rString);
                this.assignRowData(Row,js[i]);
                if(mGroup===js[i].bgid && sGroup===js[i].lgpid){
                    if(mGroup==="0")
                        mRow.items.push(Row);
                    else
                        sRow.items.push(Row);
                }
                else
                if(mGroup===js[i].bgid && sGroup!==js[i].lgpid){
                    sRow = JSON.parse(rString);
                    this.assignRowData(sRow,js[i],"S",js);
                    sRow.items.push(Row);
                    if(js[i].bgid!=="0"){
                        mRow.items.push(sRow);
                    }
                    else{
                        this.TreeViewJSON.push(sRow);
                    }
                    sGroup = js[i].lgroup;
                }
                else
                if(mGroup!==js[i].bgid){
                    
                    sGroup = js[i].lgroup;
                    mGroup = js[i].bgroup;
                    
                    mRow = JSON.parse(rString);
                    this.assignRowData(mRow,js[i],"M",js);
                    sRow = JSON.parse(rString);
                    this.assignRowData(sRow,js[i],"S",js);
                    sRow.items.push(Row);
                    if(js[i].bgid==="0"){
                        this.TreeViewJSON.push(sRow);
                    }
                    else{
                        mRow.items.push(sRow);
                        this.TreeViewJSON.push(mRow);
                    }
                }
            }
            
            $("#" + id + "_AllOP").html(this.getGroupData(js,"","OP","All"));
            $("#" + id + "_AllCR").html(this.getGroupData(js,"","CR","All"));
            $("#" + id + "_AllDR").html(this.getGroupData(js,"","DR","All"));
            $("#" + id + "_AllCL").html(this.getGroupData(js,"","CL","All"));
            
        }
    };
    
    
    this.getGroupData = function(js,id,ct,tp)
    {
        var i;
        var rv = 0;
        for(i=0;i<js.length;i++){
            if(js[i].gpid===id || js[i].lgpid===id || tp==="All"){
                if(ct==="OP")
                    rv += eval(js[i].op);
                if(ct==="DR")
                    rv += eval(js[i].dr);
                if(ct==="CR")
                    rv += eval(js[i].cr);
                if(ct==="CL")
                    rv += eval(js[i].cl);
            }
        }
        return rv;
    };
    
    this.assignRowData = function(Row,RowData,tp,js)
    {
        if(tp==="M"){
            Row.id = RowData.bgid;
            Row.ledger = RowData.bgroup;
            Row.op = this.getGroupData(js,RowData.lgpid,"OP");
            Row.cr = this.getGroupData(js,RowData.lgpid,"CR");
            Row.dr = this.getGroupData(js,RowData.lgpid,"DR");
            Row.cl = this.getGroupData(js,RowData.lgpid,"CL");
        }
        else
        if(tp==="S"){
            Row.id = RowData.lgpid;
            Row.ledger = RowData.lgroup;
            Row.op = this.getGroupData(js,RowData.lgpid,"OP");
            Row.cr = this.getGroupData(js,RowData.lgpid,"CR");
            Row.dr = this.getGroupData(js,RowData.lgpid,"DR");
            Row.cl = this.getGroupData(js,RowData.lgpid,"CL");
        }
        else{
        Row.id = RowData.ldid;
        Row.ledger = RowData.ledger;
        Row.op = RowData.op;
        Row.cr = RowData.cr;
        Row.dr = RowData.dr;
        Row.cl = RowData.cl;
        }
    };
    
    this.expandAll = function(){
        var i;
        for(i=0;i<this.DDGroupList.length;i++)
        {
            this.DDGroupList[i].expandAll();
        }
    };
    
    this.closeAll = function(){
        var i;
        for(i=0;i<this.DDGroupList.length;i++)
        {
            this.DDGroupList[i].closeAll();
        }
    };
};

function HC_DropDownGroupList(pJSON,pParentClassV)
{
    this.DDGroupList = pJSON.id || "";
    this.Container = "";
    this.ParentClassV = pParentClassV || null;
    this.SubDDGroupList = [];
    this.SubDDGroupListName = [];
    this.SubSingleList = [];
    this.SubSingleListName = [];
    this.rowJSON = pJSON || null;
    this.Type = "G";
    this.expandAll = function(){
        var i;
        if(!$("#"+this.getID()+"_SubMenuLink").hasClass("isMenuOpen")){
            $("#"+this.getID()+"_SubMenuLink").click();
        }
        for(i=0;i<this.SubDDGroupList.length;i++)
        {
        this.SubDDGroupList[i].expandAll();
        }
    };
    
    this.closeAll = function(){
        var i;
        if($("#"+this.getID()+"_SubMenuLink").hasClass("isMenuOpen")){
            $("#"+this.getID()+"_SubMenuLink").click();
        }
        for(i=0;i<this.SubDDGroupList.length;i++)
        {
        this.SubDDGroupList[i].closeAll();
        }
    };
    
    this.addSubDDGroupList = function(pJSON)
    {
        var dd = new HC_DropDownGroupList(pJSON,this);
        dd.Type = "SG";
        dd.Create(this.getID()+"_SubMenu");
        this.SubDDGroupList.push(dd);
        this.SubDDGroupListName.push(pJSON.id);
    };
    
    this.addSubSingleList = function(pJSON)
    {
        var dd = new HC_SingleList(pJSON,this);
        dd.Create(this.getID()+"_SubMenu");
        this.SubSingleList.push(dd);
        this.SubSingleListName.push(pJSON.id);
    };
    
    this.generateDDGroupList = function(pContainer,ObjTF)
    {
        if(ObjTF)
        {
           this.Container = "";
        }
        else
        {
           this.Container = pContainer;
        }
        
        var id = this.getID();
        
        if($("#"+id).length===0)
        {
            var modal = "<div id='" + id + "' class='list-group'>";
                if(this.Type==="G")
                    bgcolor = "#ED9D64";
                else
                    bgcolor = "#6699FF";
                modal +="<a href='#" + id + "_SubMenu' id='" + id + "_SubMenuLink' data-toggle='collapse' aria-expanded='false' style='background-color: " +  bgcolor +  " ;color: #ffffff;height:33px;padding:5px' class='dropdown-toggle list-group-item list-group-item-action'>";
                modal += "<div class='row no-gutter'>";
                if(this.Type==="G")
                    modal += "<div class='col-sm-8'>" + this.rowJSON.ledger + "</div>";
                else
                    modal += "<div class='col-sm-8'> &nbsp;&nbsp;&nbsp; " + this.rowJSON.ledger + "</div>";
                modal += "<div class='col-sm-1'>" + this.rowJSON.op + "</div>";
                modal += "<div class='col-sm-1'>" + this.rowJSON.dr + "</div>";
                modal += "<div class='col-sm-1'>" + this.rowJSON.cr + "</div>";
                modal += "<div class='col-sm-1'>" + this.rowJSON.cl + "</div>";
                modal += "</div>";
                modal+= "</a>";
                modal +="<div class='collapse list-unstyled' id='" + id + "_SubMenu'></div>";
            modal += "</div>";

            if(ObjTF)
                pContainer.append(modal);
            else
                $("#"+pContainer).append(modal);
            
            $("#" + id + "_SubMenuLink").click(function(){
                if(!$(this).hasClass("isMenuOpen")){
                    $(this).addClass("isMenuOpen");
                }
                else{
                    $(this).removeClass("isMenuOpen");
                }
            });
            
        }
    };
    
    this.Create = function(pContainer)
    {
        this.generateDDGroupList(pContainer,false);
    };
    
    this.CreateJQObject = function(pContainer)
    {
        this.generateDDGroupList(pContainer,true);
    };
    
    this.getID = function()
    {
        if(this.Container!=="")
            return this.Container + "_" + this.DDGroupList;
        else
            return this.SideMenu;
    };
    
    this.Dispose = function()
    {
        var id = this.getID();
        $("#"+id).remove();
        $("#"+id).remove();
    };
    
    this.setLabel = function(pLabel){
        var id = this.getID();
        this.Label = pLabel;
        $("#"+id+"_SubMenu").html(pLabel);
    };
    
    this.setInActiveAll = function(){
        var i;
        for(i=0;i<this.SubLinkMenus.length;i++)
        {
            this.SubLinkMenus[i].setActive(false);
        }
        
        for(i=0;i<this.SubDDMenus.length;i++)
        {
            this.SubDDMenus[i].setInActiveAll();
        }
    };
    
    
    this.getLinkMenu = function(pMenuName){
        var i;
        for(i=0;i<this.SubLinkMenus.length;i++)
        {
            if(pMenuName===this.SubLinkMenus[i].LinkSideMenu)
                return this.SubLinkMenus[i];
                //this.LinkMenus[i].setActive(false);
        }
        
        for(i=0;i<this.SubDDMenus.length;i++)
        {
            var mn = this.SubDDMenus[i].getLinkMenu(pMenuName);
            if(mn!==null)
                return mn;
        }
        
        return null;
    };
};

function HC_SingleList(pJSON,pParentClassV)
{
    this.SingleList = pJSON.id || "";
    this.Container = "";
    this.ParentClassV = pParentClassV || null;
    this.rowJSON = pJSON || null;
    this.Active = false;
    
    this.generateSingleList = function(pContainer,ObjTF)
    {
        if(ObjTF)
        {
           this.Container = "";
        }
        else
        {
           this.Container = pContainer;
        }
        
        var id = this.getID();
        
        if($("#"+id).length===0)
        {
            //var modal = "<a href='" + this.Link + "' id='" + id + "' class='list-group-item list-group-item-action bg-light' onlclick='OPage(\"" + this.Link + "\");'>";
            var modal = "<a href='#?p=" + this.LinkSideMenu + "' id='" + id + "' class=\"list-group-item list-group-item-action bg-light hc_sidemenuitem\" style='height:33px;padding:5px' onclick='OPage(\"" + this.LinkSideMenu + "\");'>";
                //modal += this.Label;
                modal += "<div class='row no-gutter'>";
                modal += "<div class='col-sm-8'> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; " + this.rowJSON.ledger + "</div>";
                modal += "<div class='col-sm-1'>" + this.rowJSON.op + "</div>";
                modal += "<div class='col-sm-1'>" + this.rowJSON.dr + "</div>";
                modal += "<div class='col-sm-1'>" + this.rowJSON.cr + "</div>";
                modal += "<div class='col-sm-1'>" + this.rowJSON.cl + "</div>";
                modal += "</div>";
            modal +="</a>";
            
            if(ObjTF)
                pContainer.append(modal);
            else
                $("#"+pContainer).append(modal);
        }
    };
    
    this.Create = function(pContainer)
    {
        this.generateSingleList(pContainer,false);
    };
    
    this.CreateJQObject = function(pContainer)
    {
        this.generateSingleList(pContainer,true);
    };
    
    this.getID = function()
    {
        if(this.Container!=="")
            return this.Container + "_" + this.SingleList;
        else
            return this.SingleList;
    };
    
    this.Dispose = function()
    {
        var id = this.getID();
        $("#"+id).remove();
    };
    
    this.setLabel = function(pLabel){
        var id = this.getID();
        this.Label = pLabel;
        $("#"+id).html(pLabel);
    };
    
    this.setLink = function(pLink){
        var id = this.getID();
        this.Link = pLink;
        $("#"+id).prop("href",pLink);
    };
    
    this.setActive = function(tf){
        var id = this.getID();
        this.Active = tf;
        if(tf)
            $("#"+id).css("font-weight","bold");
        else
            $("#"+id).css("font-weight","normal");
    };
    
    this.isActive = function(){
        return this.Active;
    };
};





