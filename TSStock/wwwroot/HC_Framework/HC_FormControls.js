/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

function HC_Label(CTLName)
{
    this.CTLName = CTLName || "";
    this.Label = "";
    this.BSEnable = false;
    this.ShowLabel = true;
    this.Container = "";
    this.GenrateCTL = function(CTLContainer,ObjTF)
    {
         if(ObjTF)
         {
            this.Container = "";
         }
         else
         {
            this.Container = CTLContainer;
         }
         
         var id = this.getID();
         var lbl = "<div id='" + id  + "'><span>" + this.Label + "</span></div>";
         
         if(ObjTF===false){
            $("#" + CTLContainer).append(lbl);
         }
         else{
             CTLContainer.append(lbl);
         }
         //this.setBS(this.BSEnable);
         
    };
    
    this.generateControl = function(CTLContainer)
    {
         this.GenrateCTL(CTLContainer,false);
    };
    
    this.generateControlJQObject = function(CTLContainer)
    {
        this.GenrateCTL(CTLContainer,true);
    };
    
    this.Dispose = function()
    {
        var id = this.getID();
        $("#" + id).remove();
    };
    
    this.setBS = function(tf)
    {
        var id = this.getID();
        if(tf)
        {
            $("#"+id).addClass("input-group-prepend");
            $("#"+id + " span").addClass("input-group-text");
        }
        else
        {
            $("#"+id).removeClass("input-group-prepend");
            $("#"+id + " span").removeClass("input-group-text");
        }
        this.BSEnable = tf;
    };
    
    this.setLabel = function(pLabel)
    {
        var id = this.getID();
        this.Label = pLabel;
        $("#"+id+" span").html(pLabel);
    };
    
    this.setShowLabel = function(tf)
    {
        var id = this.getID();
        this.ShowLabel = tf;
        if(tf){
            $("#"+id).show();
        }
        else{
            $("#"+id).hide();
        }
    };
    
    this.getID = function()
    {
        if(this.Container!=="")
            return this.Container + "_" + this.CTLName;
        else
            return this.CTLName;
    };
};

function HC_Hidden(CTLName)
{
    this.CTLName = CTLName || "";
    this.Text = "";
    this.Value = "";
    this.Container = "";
    
    this.getID = function()
    {
        if(this.Container!=="")
            return this.Container + "_" + this.CTLName;
        else
            return this.CTLName;
    };
    
    this.GenrateCTL = function(CTLContainer,ObjTF,pCTLName)
    {
        
         if(ObjTF)
         {
            this.Container = "";
         }
         else
         {
            this.Container = CTLContainer;
         }
         this.CTLName = pCTLName || this.CTLName;
        
         var id = this.getID();
         
         var dv = $("<div id='" + id + "_container' class='input-group mb-2 input-group-sm'></div>");
         
         var ctl = $("<input type='hidden' id='" + id + "' />");
         dv.append(ctl);
         
         if(ObjTF===false)
            $("#" + CTLContainer).append(dv);
         else
             CTLContainer.append(dv);
    };
    
    this.generateControl = function(CTLContainer,pCTLName)
    {
         this.GenrateCTL(CTLContainer,false);
    };
    
    this.generateControlJQObject = function(CTLContainer,pCTLName)
    {
         this.GenrateCTL(CTLContainer,true);
    };
    
    this.Dispose = function()
    {
        var id = this.getID();
        
        $("#"+id).remove();
        $("#"+id+"_container").remove();
        
    };
    
    this.addClass = function(Cls)
    {
        $("#"+this.getID()).addClass(Cls);
    };
    
    this.removeClass = function(Cls)
    {
        $("#"+this.getID()).removeClass(Cls);
    };
    
    this.setText = function (txt){
        $("#"+this.getID()).val(txt);
        this.Text = txt;
    };
    
    this.setValue = function (vl){
        this.Value = vl;
    };
    
    this.setTextValue = function(txt,vl)
    {
        this.setText(txt);
        this.setValue(vl);
    };
};


function HC_BaseTextBox(CTLName,pParentClassV)
{
    this.CTLName = CTLName || "";
    this.Text = "";
    this.Value = "";
    this.Label = new HC_Label(CTLName+"_label");
    this.BSColumn = "";
    this.PlaceHolder = "";
    this.NextControl = "";
    this.Required = false;
    this.ValidationType = "S";
    this.MaxLength = "50";
    this.ReadOnly = false;
    this.BSEnable = true;
    this.ParentClassV = pParentClassV || null;
    this.ShowLabel = true;
    this.Validation = null;
    this.Width = "";
    this.Height = "";
    this.TextBoxType = "TextBox";
    this.Container = "";
    this.BackColor = null;
    
    
    this.setBackColor = function(Color){
       $("#" + this.getID()).css("background-color",Color);
       this.BackColor = Color;
    };
    
    this.getBackColor = function(){
        return this.BackColor;
    };
    
    this.getID = function()
    {
        if(this.Container!=="")
            return this.Container + "_" + this.CTLName;
        else
            return this.CTLName;
    };
    
    this.GenrateCTL = function(CTLContainer,ObjTF,pCTLName)
    {
         this.CTLName = pCTLName || this.CTLName;
         if(ObjTF)
         {
            this.Container = "";
         }
         else
         {
            this.Container = CTLContainer;
         }
         
         var id = this.getID();
        
         var dv = "<div id='" + id + "_container' class='input-group mb-2 input-group-sm'></div>";
         
         if(ObjTF===false)
            $("#" + CTLContainer).append(dv);
         else
             CTLContainer.append(dv);
         
         var dv = $("#"+id+"_container");
         
         this.Label.generateControlJQObject(dv);
     
         var ctl = $("<input type='text' id='" + id + "' autocomplete='off' />");
         dv.append(ctl);
         
         var errmsg = $("<div id='" + id + "_ermsg' class='invalid-feedback order-last'></div>");
         dv.append(errmsg);
         
         this.setBS(this.BSEnable);
         this.setMaxLength(this.MaxLength);
         this.setPlaceHolder(this.PlaceHolder);
         this.setReadOnly(this.ReadOnly);
         this.setValidationType(this.ValidationType);
         this.setupEvents();
         
    };
    
    this.Dispose = function()
    {
        var id = this.getID();
        this.Label.Dispose();
        $('#'+id).unbind("keydown");
        $('#'+id).unbind("keyup");
        $('#'+id).remove();
        $("#"+id + "_ermsg").remove();
        $("#"+id + "_container").remove();
    };
    
    this.setupEvents = function()
    {
        var id = this.getID();
        var parent = this;
        
        $('#'+id).unbind("keyup");
        $('#'+id).keyup(function(e){ 
             
             var txt = $(this).val();
             
             parent.Text = txt;
             parent.Value = txt;
             
             try{
                parent.ParentClassV.TextBoxKeyUp(e,txt);
             }catch(e){};
             
         });
         $('#'+id).unbind("keydown");
         //alert($('#'+id));
         $('#'+id).keydown(function(e){ 
            
             var txt = $(this).val();
             
             try{
                parent.ParentClassV.TextBoxKeyDown(e,txt);
             }catch(e){};
             
         });
    };
    
    this.generateControl = function(CTLContainer,CTLName)
    {
         this.GenrateCTL(CTLContainer,false,CTLName);
    };
    
    this.generateControlJQObject = function(CTLContainer,CTLName)
    {
        this.GenrateCTL(CTLContainer,true,CTLName);
    };
    
    this.setBS = function(tf)
    {
        var id = this.getID();
        this.BSEnable = tf;
        var bscolumn = "";
        if(this.BSColumn!==""){
                bscolumn = "col-sm-" + this.BSColumn;
        }
        if(tf){
            
            $("#"+id+"_bscontainer").addClass("input-group mb-2 input-group-sm "+bscolumn);
            $("#"+id).addClass("form-control rounded-right");
            this.Label.setBS(true);
            
        }
        else
        {
            $("#"+id).removeClass("form-control rounded-right");
            $("#"+id+"_bscontainer").removeClass("input-group mb-2 input-group-sm "+bscolumn);
            this.Label.setBS(false);
        }
    };
    
    this.setBSColumn = function(ln)
    {
        var id = this.getID();
        var bscol = "col-sm-" + ln;
        var dv = $("#"+id + "_container");
        if(this.BSColumn===""){
            this.BSColumn = bscol;
            dv.addClass(bscol);
        }
        else{
            dv.removeClass(this.BSColumn);
            this.BSColumn = bscol;
            dv.addClass(bscol);
        }
    };
    
    this.removeBSColumn = function()
    {
        var id = this.getID();
        var dv = $("#"+id + "_container");
        dv.removeClass(this.BSColumn);
        this.BSColumn = "";
    };
    
    this.setLabel = function(pLabel)
    {
        this.Label.setLabel(pLabel);
    };
    
    this.setShowLabel = function(tf)
    {
        var id = this.getID();
        this.ShowLabel = tf;
        this.Label.setShowLabel(tf);
        if(tf){
            $("#"+id).addClass("rounded-right");
        }
        else{
            $("#"+id).removeClass("rounded-right");
        }
    };
    
    this.setPlaceHolder = function(pPlaceHolder)
    {
        var id = this.getID();
        this.PlaceHolder = pPlaceHolder;
        $("#"+id).prop("placeholder",pPlaceHolder);
    };
    
    this.setValidationType = function(pValidationType)
    {
        var id = this.getID();
        this.ValidationType = pValidationType;
        
        if(pValidationType==="UID")
            $('#' + id).mask('0000-0000-0000',{placeholder: '____-____-____'});
        
        if(pValidationType==="M")
            $('#' + id).mask('0000000000',{placeholder: '__________'});
        
        if(pValidationType==="C")
            $('#' + id).mask('000000',{placeholder: '______'});
        
        if(pValidationType==="TM")
            $('#' + id).mask('00:00',{placeholder: '__:__'});
        
    };
    
    this.setMaxLength = function(pMaxLength){
        var id = this.getID();
        this.MaxLength = pMaxLength;
        $('#' + id).prop("maxlength",pMaxLength);
    };
    
    this.setReadOnly = function(pReadOnly){
        var id = this.getID();
        this.ReadOnly = pReadOnly;
        $('#' + id).prop("readonly",pReadOnly);
    };
    
    this.validateBlank = function()
    {
       this.Validation = new HC_Validation(this.Container + "_" + this.CTLName,this.ValidationType,this.Label);
       return this.Validation.selfValidateBlank();
    };
    
    this.validateVTP = function()
    {
       return this.Validation.selfValidateVTP(this.Text);
    };
    
    this.addClass = function(Cls)
    {
        $("#"+this.getID()).addClass(Cls);
    };
    
    this.removeClass = function(Cls)
    {
        $("#"+this.getID()).removeClass(Cls);
    };
    
    this.setWidth = function(pWidth)
    {
        $("#"+this.getID()).css("width",pWidth+"px");
        this.Width = pWidth;
    };
    
    this.setHeight = function(pHeight)
    {
        $("#"+this.getID()).css("height",pHeight+"px");
        this.Width = pHeight;
    };
    
    this.setFocus = function()
    {
        var id = this.getID();
        $("#"+id).focus();
        $("#"+id).select();
    };
    
    this.convertToPassword = function()
    {
        $("#"+this.getID()).prop("type","password");
        this.TextBoxType = "Password";
    };
    
    this.convertToTextArea = function()
    {
        var id = this.getID();
        var textarea = $(document.createElement('textarea'));
        textarea.addClass("form-control");
        textarea.prop("id",id);
        $("#"+id).replaceWith(textarea);
        
        this.TextBoxType = "TextArea";
        
        var parent = this;
        
        $('#'+id).keyup(function(e){ 
             
             var txt = $(this).val();
             
             parent.Text = txt;
             parent.Value = txt;
             
             try{
                parent.ParentClassV.TextBoxKeyUp(e,txt);
             }catch(e){};
             
         });
         
         $('#'+id).keydown(function(e){ 
             
             var txt = $(this).val();
             
             try{
                parent.ParentClassV.TextBoxKeyDown(e,txt);
             }catch(e){};
             
             if(e.which===13 && window.event.ctrlKey)
             {
                 parent.ParentClassV.TextAreaEnter();
             }
         });
    };
    
    this.validateBlank = function(){
        var tb = this.getID();
        if(this.Text.trim()==="")
        {
            $("#"+tb).removeClass("is-valid");
            $("#"+tb).addClass("is-invalid");
            $("#"+tb+"_ermsg").html("Please Enter " + this.Label.Label);
            return this;
        }
        else{
            $("#"+tb).addClass("is-valid");
            $("#"+tb).removeClass("is-invalid");
            $("#"+tb+"_ermsg").html("");
            return null;
        }
    };
    
    this.validateVTP = function(){
        var tb = this.getID();
        var msg = checkVTP(this.Text,this.ValidationType);
        if(msg!=="")
        {
            $("#"+tb).removeClass("is-valid");
            $("#"+tb).addClass("is-invalid");
            $("#"+tb+"_ermsg").html("Please Enter " + msg);
            return this;
        }
        else{
            $("#"+tb).addClass("is-valid");
            $("#"+tb).removeClass("is-invalid");
            $("#"+tb+"_ermsg").html("");
            return null;
        }
    };
    
    this.setText = function (txt){
        $("#"+this.getID()).val(txt);
        this.Text = txt;
    };
    
    this.setValue = function (vl){
        this.Value = vl;
    };
    
    this.setTextValue = function(txt,vl)
    {
        this.setText(txt);
        this.setValue(vl);
    };
};

function HC_BaseSelect(CTLName,pParentClassV)
{
    this.CTLName = CTLName || "";
    this.Text = "";
    this.Value = "";
    this.Label = new HC_Label(CTLName+"_label");
    this.BSColumn = "";
    this.PlaceHolder = "";
    this.NextControl = "";
    this.Required = false;
    this.ValidationType = "S";
    this.ReadOnly = false;
    this.BSEnable = true;
    this.ParentClassV = pParentClassV || null;
    this.ShowLabel = true;
    this.Validation = null;
    this.Width = "";
    this.Height = "";
    this.SelectedIndex;
    this.Container = "";
    
    this.getID = function()
    {
        if(this.Container!=="")
            return this.Container + "_" + this.CTLName;
        else
            return this.CTLName;
    };
    
    this.GenrateCTL = function(CTLContainer,ObjTF,pCTLName)
    {
         if(ObjTF)
         {
            this.Container = "";
         }
         else
         {
            this.Container = CTLContainer;
         }
         this.CTLName = pCTLName || this.CTLName;
         
         var id = this.getID();
         
         var dv = "<div id='" + id + "_container' class='input-group mb-2 input-group-sm'></div>";
         
         if(ObjTF===false)
            $("#" + CTLContainer).append(dv);
         else
             CTLContainer.append(dv);
         
         var dv = $("#"+id+"_container");
         
         this.Label.generateControlJQObject(dv);
         
         var ctl = $("<select type='text' id='" + id + "'></select>");
         dv.append(ctl);
         
         var errmsg = $("<div id='" + id + "_ermsg' class='invalid-feedback order-last'></div>");
         dv.append(errmsg);
         
         this.setBS(this.BSEnable);
         this.setReadOnly(this.ReadOnly);
         this.setValidationType(this.ValidationType);
         this.setupEvents();
         
    };

    this.Dispose = function()
    {
        var id = this.getID();
        this.Label.Dispose();
        $('#'+id).unbind("keydown");
        $('#'+id).unbind("keyup");
        $('#'+id).remove();
        $("#"+id + "_ermsg").remove();
        $("#"+id + "_container").remove();
    };

    this.setupEvents = function()
    {
        var id = this.getID();
        var parent = this;
        
        $('#'+id).keyup(function(e){ 
             
             var txt = $(this).val();
             
             parent.Text = txt;
             parent.Value = txt;
             
             if(parent.ParentClassV!==null)
                parent.ParentClassV.TextBoxKeyUp(e,txt);
             
         });
         
         
         $('#'+id).keydown(function(e){ 
             
             var txt = $(this).val();
             
             if(parent.ParentClassV!==null)
                parent.ParentClassV.TextBoxKeyDown(e,txt);
             
         });
         
         $("#"+id).change(function(){
             
            parent.Text = $(this).find(":checked").val();
            parent.SelectedIndex = $(this).find(":checked").index();
            if(parent.ParentClassV!==null)
                parent.Value = parent.ParentClassV.json[parent.SelectedIndex].id;
            
            try{
                window[parent.CTLName+"_BaseSelect"](parent.Text,parent.Value,parent.SelectedIndex,parent.Container);
            }catch(e){}

            try{
                parent.ParentClassV.HC_BaseSelect_DataSelected(parent.Text,parent.Value,parent.SelectedIndex,parent.Container);
                //The following functions used call parent 
            }catch(e){} 
            
         });
         
    };
    
    this.generateControl = function(CTLContainer,pCTLName)
    {
         this.GenrateCTL(CTLContainer,false,pCTLName);
    };
    
    this.generateControlJQObject = function(CTLContainer,pCTLName)
    {
         this.GenrateCTL(CTLContainer,true,pCTLName);
    };
    
    this.setBS = function(tf)
    {
        var id = this.getID();
        this.BSEnable = tf;
        var bscolumn = "";
        
        if(this.BSColumn!==""){
            bscolumn = "col-sm-" + this.BSColumn;
        }
        
        if(tf){
            
            $("#"+id+"_bscontainer").addClass("input-group mb-2 input-group-sm "+bscolumn);
            $("#"+id).addClass("form-control rounded-right");
            this.Label.setBS(true);
            
        }
        else
        {
           $("#"+id).removeClass("form-control rounded-right");
           $("#"+id+"_bscontainer").removeClass("input-group mb-2 input-group-sm "+bscolumn);
           this.Label.setBS(false);
        }
    };
    
    this.setBSColumn = function(ln)
    {
        var id = this.getID();
        var bscol = "col-sm-" + ln;
        var dv = $("#"+id + "_container");
        if(this.BSColumn===""){
            this.BSColumn = bscol;
            dv.addClass(bscol);
        }
        else{
            dv.removeClass(this.BSColumn);
            this.BSColumn = bscol;
            dv.addClass(bscol);
        }
    };
    
    this.removeBSColumn = function()
    {
        var id = this.getID();
        var dv = $("#"+id + "_container");
        dv.removeClass(this.BSColumn);
        this.BSColumn = "";
    };
    
    this.setLabel = function(pLabel)
    {
        var id = this.getID();
        this.Label = pLabel;
        $("#"+id + "_label span").html(pLabel);
    };
    
    this.setShowLabel = function(tf)
    {
        var id = this.getID();
        this.ShowLabel = tf;
        if(tf){
            $("#"+id + "_label").show();
            $("#"+id).addClass("rounded-right");
        }
        else{
            $("#"+id + "_label").hide();
            $("#"+id).removeClass("rounded-right");
        }
    };
    
    this.setValidationType = function(pValidationType)
    {
        var id = this.getID();
        this.ValidationType = pValidationType;
        
        if(pValidationType==="UID")
            $('#' + id).mask('0000-0000-0000',{placeholder: '____-____-____'});
        
        if(pValidationType==="M")
            $('#' + id).mask('0000000000',{placeholder: '__________'});
        
        if(pValidationType==="C")
            $('#' + id).mask('000000',{placeholder: '______'});
        
        if(pValidationType==="TM")
            $('#' + id).mask('00:00',{placeholder: '__:__'});
        
    };
    
    this.setReadOnly = function(pReadOnly){
        var id = this.getID();
        this.ReadOnly = pReadOnly;
        $('#' + id).prop("readonly",pReadOnly);
    };
    
    this.validateBlank = function()
    {
       this.Validation = new HC_Validation(this.getID(),this.ValidationType,this.Label);
       return this.Validation.selfValidateBlank();
    };
    
    this.validateVTP = function()
    {
       return this.Validation.selfValidateVTP(this.Text);
    };
    
    this.addClass = function(Cls)
    {
        $("#"+this.getID()).addClass(Cls);
    };
    
    this.removeClass = function(Cls)
    {
        $("#"+this.getID()).removeClass(Cls);
    };
    
    this.setWidth = function(pWidth)
    {
        $("#"+this.getID()).css("width",pWidth+"px");
        this.Width = pWidth;
    };
    
    this.setHeight = function(pHeight)
    {
        $("#"+this.getID()).css("height",pHeight+"px");
        this.Width = pHeight;
    };
    
    
    this.setFocus = function()
    {
        $("#"+this.getID()).focus();
    };
    
    this.validateBlank = function(){
        var tb = this.getID();
        if(this.Text.trim()==="")
        {
            $("#"+tb).removeClass("is-valid");
            $("#"+tb).addClass("is-invalid");
            $("#"+tb+"_ermsg").html("Please Enter " + this.Label);
            return this;
        }
        else{
            $("#"+tb).addClass("is-valid");
            $("#"+tb).removeClass("is-invalid");
            $("#"+tb+"_ermsg").html("");
            return null;
        }
    };
    
    this.validateVTP = function(){
        var tb = this.getID();
        var msg = checkVTP(this.Text,this.ValidationType);
        if(msg!=="")
        {
            $("#"+tb).removeClass("is-valid");
            $("#"+tb).addClass("is-invalid");
            $("#"+tb+"_ermsg").html("Please Enter " + msg);
            return this;
        }
        else{
            $("#"+tb).addClass("is-valid");
            $("#"+tb).removeClass("is-invalid");
            $("#"+tb+"_ermsg").html("");
            return null;
        }
    };
    
    this.setText = function(txt)
    {
        $('#'+this.getID()).val(txt);
        this.Text = txt;
    };
    
    this.setValue = function(vl)
    {
        this.Value = vl;
    };
    
    this.setIndex = function(idx)
    {
        this.SelectedIndex = idx;
    };
};


function HC_TextBox(CTLName,pParentClassV)
{
    this.CTLName = CTLName || "";
    this.Text = "";
    this.Value = "";
    this.ParentClassV = pParentClassV || null;
    this.NextControl = null;
    this.TextBox = new HC_BaseTextBox(CTLName,this);
    this.Container = "";
    
    this.setBackColor = function(Color){
       this.TextBox.setBackColor(Color);
    };
    
    this.getBackColor = function(){
        return this.TextBox.getBackColor();
    };
   
    this.getID = function()
    {
        if(this.Container!=="")
            return this.Container + "_" + this.CTLName;
        else
            return this.CTLName;
    };
    
    this.moveToContainer = function(pContainer)
    {
        var id = this.getID();
        $("#"+id+"_container").detach().appendTo("#"+pContainer);
    };
    
    this.TextAreaEnter = function()
    {
        this.gotoNextControl();
    };
    
    this.generateControl = function(CTLContainer,CTLName)
    {
         this.TextBox.generateControl(CTLContainer,CTLName);
    };
    
    this.generateControlJQObject = function(CTLContainer,CTLName)
    {
         this.TextBox.generateControlJQObject(CTLContainer,CTLName);
    };
      
    this.TextBoxKeyUp = function(e,txt)
    {
        if(e.which===13 && this.TextBox.TextBoxType!=="TextArea")
        {
            this.gotoNextControl();
            
            try{
                this.ParentClassV.HC_TextBox_DataSelected(txt);
            }catch(e){} 
        }
        try{
            this.ParentClassV.HC_TextBox_KeyUp(e,txt);
        }catch(e){} 
        
        this.Text = txt;
        this.Value = txt;
    };
    
    this.TextBoxKeyDown = function(e,txt)
    {
        try{
            this.ParentClassV.HC_TextBox_KeyDown(e,txt);
        }catch(e){} 
    };
    
    this.setText = function(txt)
    {
        this.Text = txt;
        this.TextBox.setText(txt);
    };
    
    this.setValue = function(vl)
    {
        this.Value = vl;
        this.TextBox.setValue(vl);
    };
    
    this.clearAll = function()
    {
        this.setText("");
        this.setValue("");
        $('#'+this.getID()).removeClass("is-valid");
        this.TextBox.setText("");
        this.TextBox.setValue("");
    };
    
    this.setFocus = function(){
        this.TextBox.setFocus();
    };
    
    this.gotoNextControl = function()
    {
        if(this.NextControl!==null)
        {
            try{
                this.NextControl.setFocus();
            }catch(e){};
            
            try{
                window[this.getID()+"_gotoNextControl"](this.CTLName,this.NextControl);
            }catch(e){};
            
            try{
                if(this.ParentClassV!==null){
                    this.ParentClassV.gotoNextControl(this.CTLName,this.NextControl);
                }
            }catch(e){alert(e);};
        }
    };
    
    this.Dispose = function()
    {
        this.TextBox.Dispose();
    };
    
    this.setLabel = function(pLabel)
    {
        this.TextBox.setLabel(pLabel);
    };
    
    this.setShowLabel = function(tf)
    {
        this.TextBox.setShowLabel(tf);
    };
    
    this.setPlaceHolder = function(pPlaceHolder)
    {
        this.TextBox.setPlaceHolder(pPlaceHolder);
    };
    
    this.setValidationType = function(pValidationType)
    {
        this.TextBox.setValidationType(pValidationType);
    };
    
    this.setMaxLength = function(pMaxLength){
        this.TextBox.setMaxLength(pMaxLength);
    };
    
    this.setReadOnly = function(pReadOnly){
        this.TextBox.setReadOnly(pReadOnly);
    };
    
    this.setBSColumn = function(ln)
    {
        this.TextBox.setBSColumn(ln);
    };
    
    this.validateBlank = function(){
        if(this.TextBox.validateBlank()!==null)
            return this;
        else
            return null;
    };
    
    this.validateVTP = function(){
        if(this.TextBox.validateVTP()!==null)
            return this;
        else
            return null;
    };
    
    this.setTextValue = function(txt,vl)
    {
        this.setText(txt);
        this.setValue(vl);
    };
    
    this.setMaxLength = function(ln)
    {
        this.TextBox.setMaxLength(ln);
    };
    
};

function HC_AutoCompleteJSON(CTLName,pTextField,pValueField,pColumns,pJSON,pParentClassV)
{
    this.CTLName = CTLName || "";
    this.IsGridViewOpen = false;
    this.GridView =  new HC_GridView(CTLName+"_Search",this);
    this.TextField = pTextField || "";
    this.ValueField = pValueField || "";
    this.Columns = pColumns || "";
    this.JSONData = pJSON;
    this.Text = "";
    this.Value = "";
    this.SelectRowIndex = -1;
    this.TextBox = new HC_BaseTextBox(CTLName,this);
    this.ParentClassV = pParentClassV || null;
    this.GridViewWidth = 500;
    this.GridViewHeight = 150;
    this.Ajax = new HC_Ajax();
    this.NextControl = null;
    this.Container = "";
    this.ACColWidth = "";
    this.isSearched = false;
    this.TempTXT = "";
    this.ComboBox = false;
    
    this.setBackColor = function(Color){
       this.TextBox.setBackColor(Color);
    };
    
    this.getBackColor = function(){
        return this.TextBox.getBackColor();
    };
    
    this.moveToContainer = function(pContainer)
    {
        var id = this.CTLName;
        $("#"+id+"_container").detach().appendTo("#"+pContainer);
    };
    
    this.setACColWidth = function()
    {
        if(this.ACColWidth.trim()!=="")
        {
            var ar = this.ACColWidth.split(',');
            
            for(var i=0;i<=ar.length;i++)
            {
                if(ar[i]!==undefined){
                    
                    var car = ar[i].split(':');

                    try{
                    if(car[0]==="H")
                    {
                        this.GridView.setGridViewHeight(car[1]);
                    }
                    else
                    if(car[0]==="W")
                    {
                        this.GridView.setGridViewWidth(car[1]);
                    }
                    else
                    if(eval(car[0])<this.GridView.getColumnLength())
                        this.GridView.setColumnWidth(car[0],car[1]);
                    }catch(ee){alert(ee);}
                }
            }
        }   
    };
    
    this.getID = function()
    {
        //alert(this.Container);
        if(this.Container!=="")
            return this.Container + "_" + this.CTLName;
        else
            return this.CTLName;
        
        //return this.CTLName;
    };
    
    this.setText = function(txt)
    {
        //alert("Set Text " + txt);
        this.Text = txt;
        this.TextBox.setText(txt);
        if(txt!==""){
            this.SelectRowIndex = this.getTextIndex(txt);
        }
    };
    
    this.getTextIndex = function(data)
    {
        if(data!=="")
        {
            if(JSON.stringify(this.GridView.data)!=="")
            {
                for(var i=0;i<this.GridView.data.matrix.length;i++)
                {
                    if(data===this.GridView.data.matrix[i][this.TextField])
                    {
                        return i;
                    }
                }
            }
        }
        return -1;
    };
    
    this.setValue = function(txt)
    {
        this.Value = txt;
        this.TextBox.setValue(txt);
    };
    
    this.clearAll = function()
    {
        this.setText("");
        this.setValue("");
        $('#'+this.CTLName).removeClass("is-valid");
        this.TextBox.setText("");
        this.TextBox.setValue("");
    };
    
    this.Dispose = function()
    {
        var id = this.getID();
        
        this.TextBox.Dispose();
        
        $("#" + id + "_GridView").remove();
        $("#" + id + "_AutoCompleteContainer").remove();
    };
    
    this.TextBoxKeyUp = function(e,txt)
    {
        var id = this.getID();
        
        if(e.which === 13)
        {
            var rwi = eval(this.SelectRowIndex);
            // alert(rwi);
            if(rwi!==undefined){
                //if(this.SelectRowIndex!==rwi){
                //alert(rwi);
                    if(rwi>=0)
                    {
                        if(this.ComboBox && this.GridView.getRowLength()==0){
                            this.setText(txt);
                            this.setValue(txt);
                            this.DataSelected(null,-1);
                        }
                        else
                            this.DataSelected(this.GridView.getJSONMatrix(rwi), rwi);
                    }
                    else
                    {
                        if(this.ComboBox){
                            this.setText(txt);
                            this.setValue(txt);
                            this.DataSelected(null,-1);
                        }
                        else{
                        this.DataSelected(null,-1);
                        this.setText("");
                        this.setValue("");
                        if(txt!=="")
                            alert("Data Not Found");
                        }
                    }
                }
                else
                {
                    if(this.ComboBox){
                        this.setText(txt);
                        this.setValue(txt);
                        this.DataSelected(null,-1);
                    }
                    else{
                    this.DataSelected(null,-1);
                    this.setText("");
                    this.setValue("");
                    alert("Data Not Found");
                    }
                }
            //}
            this.gotoNextControl();
        }
        else
        if(e.which === 40 || e.which === 113){ 
            if(!this.IsGridViewOpen){
                this.OpenSearch(); 
            }
            else{
                this.GridView.focusNextRow();
            }
        }
        else
        if(e.which === 38){ 
            this.GridView.focusPrevRow(); 
        }
        if(e.which === 27)
        {
            this.CloseSearch();
        }
        else
        {
            if(this.TempTXT!==txt)
                {
                    this.GridView.SearchGRID(txt);
                }
        }
        //alert(this.TempTXT);
        //alert(txt);
        if(txt.length>0)
        {
            this.OpenSearch();
        }
        
        try{
            this.ParentClassV.HC_AutoCompleteJSON_KeyUp(e,txt);
        }catch(e){} 
    };
    
    this.TextBoxKeyDown = function(e,txt)
    {
        //if(e.which !== 40 && e.which !== 113 && e.which !== 9 && e.which !==13){ 
       //     e.preventDefault();
        //}
        
        this.TempTXT = txt;
        
        try{
            this.ParentClassV.HC_AutoCompleteJSON_KeyDown(e,txt);
        }catch(e){} 
    };
    
    
    this.generateControlJQObject = function(CTLContainer)
    {
         try{
         
         this.Container = "";
             
         var id = this.getID();
         var parent = this;
         //alert(id);
         this.TextBox.generateControlJQObject(CTLContainer);
         
         var dv = $("#" + id + "_container");
         dv.addClass("HC_AutoCompleContainer");
         
         dv.append("<button id='" + id + "_btndd' class='btn btn-outline-secondary btn-sm dropdown-toggle' style='padding-left:5px;padding-right:5px;border-radius: 0px 3px 3px 0px'></button>");
         
         var dvgrd = $("<div id='" + id + "_GridView' class='HC_AutoCompleGridView HC_AutoCompleItemContainer'></div>");
         dv.append(dvgrd);
         
         $("#"+id).css("border-radius","none");
         
         CTLContainer.append(dv);
           
            var jsonString = JSON.stringify(this.JSONData);
            this.GridView.CreateGridObject($("#"+id+"_GridView"));
            //Adding Colummns Start
                var ar = this.Columns.split(',');
                for(i=0;i<ar.length;i++){
                    this.GridView.AddColumn(ar[i],ar[i]);
                }
            //Adding Columns End
            
            if(this.JSONData!==null && this.JSONData!==undefined)
            {
                if(jsonString!==""){
                    this.populateUsingJSON(jsonString);
                }
            }
            
            //this.GridView.setSearching(true);
            this.GridView.setDefaultWidth(false);
            this.GridView.setGridViewWidth(this.GridViewWidth);
            this.GridView.setScrollBarX(true);
            this.GridView.setScrollBarY(true);
            this.GridView.setGridViewHeight(this.GridViewHeight);
            this.GridView.defineEvents();
            
             this.setGridViewHeight(this.GridViewHeight);
             this.setGridViewWidth(this.GridViewWidth);
             $("#"+id+"_GridView").hide();

            $("#"+id).focusout(function(){
                parent.CloseSearchDelay();
            }); 
         
            $("#"+id+"_btndd").click(function(){
                (new HC_Timer()).CallAfter(function(){
                    parent.OpenSearch();
                    $("#"+id).focus();
                },400);
            }); 
            
            
            $("#"+id).focus(function(){
                if(parent.ComboBox){
                    parent.Text = $(this).val();
                    parent.Value = $(this).val();
                }
            });
            
            /*$("#"+id).focus(function(){
                $("#"+id+"_btndd").val(parent.SelectRowIndex);
            });*/
            
         }catch(eee){alert(eee);}
    };
    
    
    this.GridViewSearchEnd = function(x)
    {
        var parent = this;
        (new HC_Timer()).CallAfter(function(){
            parent.GridView.focusRow(0);
        },300);
    };
    
    this.generateControl = function(CTLContainer)
    {
         this.Container = CTLContainer;
             
         var id = this.getID();
         
         var parent = this;
         
         this.TextBox.generateControl(CTLContainer);
         
         var dv = $("#" + id + "_container");
         dv.addClass("HC_AutoCompleContainer");
         var dvgrd = $("<div id='" + id + "_GridView' class='HC_AutoCompleGridView HC_AutoCompleItemContainer'></div>");
         dv.append(dvgrd);
         
         $("#" + CTLContainer).append(dv);
         
         //$('#'+id).focusin(function(){ try{ parent.OpenSearch(); }catch(e){alert(e);} });         
         
            var jsonString = JSON.stringify(this.JSONData);
            this.GridView.Create(id+"_GridView");
            //Adding Colummns Start
                var ar = this.Columns.split(',');
                for(i=0;i<ar.length;i++)
                    this.GridView.AddColumn(ar[i],ar[i]);
            //Adding Columns End
            
            if(this.JSONData!==null)
            {
                if(this.JSONData!=="")
                    this.populateUsingJSON(jsonString);
            }
            
            //this.GridView.setSearching(false);
            this.GridView.setDefaultWidth(false);
            this.GridView.setGridViewWidth(this.GridViewWidth);
            this.IsGridViewOpen = true;
            this.GridView.setScrollBarX(true);
            this.GridView.setScrollBarY(true);
            this.GridView.setGridViewHeight(this.GridViewHeight);
            if(this.SelectRowIndex>=0)
                this.GridView.focusRow(this.SelectRowIndex);
            this.GridView.defineEvents();

             this.setGridViewHeight(this.GridViewHeight);
             this.setGridViewWidth(this.GridViewWidth);
             $("#"+id+"_GridView").hide();
             
            $("#"+id+"_Search_search").focusout(function(){
                parent.CloseSearchDelay();
            }); 
            
            
            $("#"+id+"_Search_search").focusin(function(){
                if(parent.ComboBox){
                    alert($(this).val());
                    parent.Text = $(this).val();
                    parent.Value = $(this).val();
                }
            }); 
    };
    
    this.GridViewAddRow = function()
    {
        var id = this.getID();
        var parent = this;
        $("#"+id+"_GridView tbody tr").unbind("click");
        $("#"+id+"_GridView tbody tr").click(function(){
            var idx = $(this).index();
            parent.DataSelected(parent.GridView.getJSONMatrix(idx),idx);
        });
    };
    
    this.OpenSearch = function()
    {
        
        if(!this.IsGridViewOpen)
        {
            try{
             var id = this.getID();
             var parent = this;
             this.setACColWidth();
             var sri = this.getIndexFromValue();
             //alert(id);

             //this.GridView.setColumnHeaderText(0,sri);

            $("#"+id+"_GridView").show();
            //alert($("#"+id+"_GridView").length);
            $("#"+id+"_GridView").css("height",eval(this.GridView.Height) + 55);
            $("#"+id+"_GridView").css("width",eval(this.GridView.Width));


            this.GridView.ShowAllRows();

            ///(new HC_Timer()).CallAfter(function(){
            //alert(sri);
            
            (new HC_DelayCall()).Call(function(){
                //alert(sri);
                if(sri<0){
                    parent.GridView.focusRow(0);
                }
                else{
                    if(parent.GridView.Paging){
                        parent.GridView.gotoPage(parent.GridView.getPageNoFromRowIndex(sri));
                        parent.GridView.SelectSingleRow(parent.GridView.getPageRowIndexFromRowIndex(sri));
                        parent.SelectRowIndex = sri;
                    }
                    else{
                        parent.GridView.focusRow(sri);
                        parent.SelectRowIndex = sri;
                    }
                }

            });


            //},500);

            //if(this.SelectRowIndex>=0){
                //this.GridView.SearchGRID(this.Text);
            //}

            this.IsGridViewOpen = true;

            }catch(e){alert(e);}

            try{
                this.ParentClassV.HC_AutoCompleteJSON_OpenSearch(this.Container);
            }catch(e){} 

            try{
                window[this.CTLName+"_OpenSearch"](this.Container);
            }catch(e){};
        
        }
    };
    
    this.getIndexFromValue = function()
    {
        var vl = this.Value;
        for(var i=0;i<this.GridView.basedata.matrix.length;i++)
        {
            if(this.GridView.basedata.matrix[i][this.ValueField]==vl)
                return i;
        }
        return -1;
    };
    
    this.DataSelected = function(rwjson,rwi)
    {
        //var id = this.getID();
        //if(rwi>=0){
        
            if(rwjson!==null){
        
            //alert(JSON.stringify(rwjson));
            
            if(this.TextField!==""){
                this.setText(rwjson[this.TextField]);
            }
            
            if(this.ValueField!=="")
                this.Value = rwjson[this.ValueField];
            }
            
            this.SelectRowIndex = rwi;
            this.isSearched = true;
            
            //this.CloseSearch();
        //}
        
        try{
            window[this.CTLName+"_DataSelected"](rwjson,rwi,this.Container);
        }catch(e){}

        try{
            this.ParentClassV.HC_ACList_DataSelected(rwjson,rwi,this.Container);
        }catch(e){} 
        
        this.CloseSearch();
    };
    
    this.CloseSearch = function()
    {
        var id = this.getID();
        this.IsGridViewOpen = false;
        $("#"+id+"_GridView").hide();
        
        try{
            this.ParentClassV.HC_AutoCompleteJSON_CloseSearch(this.Container);
        }catch(e){} 
        
        try{
            window[this.CTLName+"_CloseSearch"](this.Container);
        }catch(e){};
    };
    
    this.CloseSearchDelay = function()
    {
        var parent = this;
        var tm;
        tm = setInterval(function() {
            parent.CloseSearch();
            clearInterval(tm);
        },400);
    };
    
    this.EscapePressed = function()
    {
        this.CloseSearch();
    };
    
    this.setGridViewHeight = function(height){
        var id = this.getID();
        this.GridViewHeight = height;
        if(this.GridView!==null){
            this.GridView.setGridViewHeight(height);
        }
        
        $("#"+id+"_GridView").css("height",height+2);
    };
    
    this.setGridViewWidth = function(width){
        this.GridViewWidth = width;
        var id = this.getID();
        if(this.GridView!==null){
            this.GridView.setGridViewWidth(width);
        }
        $("#"+id+"_GridView").css("width",width+2);
    };
    
    this.addRow = function(vl,txt,pos)
    {
        var id = this.getID();
        if(pos===undefined){
            this.GridView.addRow();
            var li = this.GridView.getRowLength() - 1;
            this.GridView.setHTML(li,0,vl);
            this.GridView.setHTML(li,1,txt);
        }
        else{
            this.GridView.addRow(pos);
            this.GridView.setHTML(pos,0,vl);
            this.GridView.setHTML(pos,1,txt);
        }
        
        try{
            this.ParentClassV.HC_AutoCompleteJSON_AddRow(vl,txt,pos,this.Container);
        }catch(e){} 
        
        try{
            window[id+"_AddRow"](vl,txt,pos,this.Container);
        }catch(e){};
    };
    
    this.removeRow = function(pos)
    {
        var id = this.getID();
        if(idx<this.GridView.getRowLength())
        {
            this.GridView.removeRow(pos);
            
            try{
                this.ParentClassV.HC_AutoCompleteJSON_RemoveRow(pos,this.Container);
            }catch(e){} 
        
            try{    
                window[id+"_RemoveRow"](pos,this.Container);
            }catch(e){};
        }
    };
    
    this.removeRowAll = function()
    {
        this.GridView.clearAllRows();
    };
    
    this.populateUsingJSON = function(data)
    {
        this.GridView.populateUsingJSON(data);
        
        //this.GridView.SyncJSONToGridView();
        //this.GridView.defineEvents();
        /*try{
        var json = new HC_Json(data);
        var i,j;
        var ar = this.Columns.split(',');
        var stpt = 0;
        if(Append===true)
            var stpt = this.GridView.getRowLength();
            var trr = this.GridView.getTableRow();
            var grid = this.GridView.getID();
            alert(grid);
            alert(data);
        for(i=stpt;i<stpt+json.getArRowLength();i++){
            //this.GridView.addRow();
            $("#" + grid + " tbody").append(trr);
            alert(JSON.stringify(this.GridView.getJSONMatrix(i)));
            var jsonGrid = new HC_Json(JSON.stringify(this.GridView.getJSONMatrix(i)));
            for(j=0;j<ar.length;j++)
            {   
                var ci = jsonGrid.getArIFK(ar[j]);
                if(json.getArVK((i-stpt),ar[j])!==null)
                    this.GridView.setHTML(i,ci,json.getArVK((i-stpt),ar[j]));
                else
                    this.GridView.setHTML(i,ci,"");
            }
        }
        }catch(eee){alert(eee);}*/
    };
    
    this.populatefromAjax = function(AjaxID,WhereCL,Append){
        this.Ajax.AjaxID = AjaxID;
        this.Ajax.CMN_WhereCL = WhereCL;
        this.Ajax.CMN_WhereData = '';
        var parent = this;
        this.Ajax.CallServer(function(data){
            try{
                
            if(data!=="[]"){    
                //alert(data);
                var jsn = JSON.parse(data);
                var jsonObj = jsn;
                parent.JSONData = jsn;
                var fr = JSON.stringify(jsonObj[0]);
                fr = JSON.parse(fr);
                for (var x in fr)
                    fr[x]="";
                
                jsonObj.splice(0,0,fr);
                
                if(Append===false || Append===undefined){
                    parent.removeRowAll();
                    parent.populateUsingJSON(JSON.stringify(jsonObj));
                }
                else{
                    parent.populateUsingJSON(JSON.stringify(jsonObj));
                }
                
                //alert(parent.Text);
                
               /* if(parent.Text!=""){
                    
                    parent.SearchAssignLocal(parent.TextField,parent.Text);
                }*/
                
            }
            }catch(eee){alert(eee);}
            
        });
    };
    
    
    this.populatefromAjaxandSearch = function(AjaxID,WhereCL,key,vl,Append){
        this.Ajax.AjaxID = AjaxID;
        this.Ajax.CMN_WhereCL = WhereCL;
        this.Ajax.CMN_WhereData = '';
        var parent = this;
        this.Ajax.CallServer(function(data){
            try{
            if(data!=="[]"){    
                var jsn = JSON.parse(data);
                var jsonObj = jsn;
                parent.JSONData = jsn;
                var fr = JSON.stringify(jsonObj[0]);
                fr = JSON.parse(fr);
                for (var x in fr)
                    fr[x]="";
                
                jsonObj.splice(0,0,fr);

                if(Append===false || Append===undefined){
                    parent.removeRowAll();
                    parent.populateUsingJSON(JSON.stringify(jsonObj),false);
                   
                }
                else{
                    parent.populateUsingJSON(JSON.stringify(jsonObj),true);
                }
                
                
                 parent.SearchAssignLocal(key,vl);
            }
            }catch(eee){alert(eee);}
            
        });
    };
    
    
    this.setFocus = function(){
        this.TextBox.setFocus();
    };
    
    this.gotoNextControl = function()
    {
        var id = this.getID();
        if(this.NextControl!==null)
        {
            try{
                this.NextControl.setFocus();
            }catch(e){}
            
            try{
                window[id+"_gotoNextControl"](this.CTLName,this.NextControl,this.Container);
            }catch(e){};
            
            try{
                if(this.ParentClassV!==null){
                    this.ParentClassV.gotoNextControl(this.CTLName,this.NextControl,this.Container);
                }
            }catch(e){};
        }
    };
    
    this.setLabel = function(pLabel)
    {
        this.TextBox.setLabel(pLabel);
    };
    
    this.setShowLabel = function(tf)
    {
        this.TextBox.setShowLabel(tf);
    };
    
    this.setPlaceHolder = function(pPlaceHolder)
    {
        this.TextBox.setPlaceHolder(pPlaceHolder);
    };
    
    this.setValidationType = function(pValidationType)
    {
        this.TextBox.setValidationType(pValidationType);
    };
    
    this.setMaxLength = function(pMaxLength){
        this.TextBox.setMaxLength(pMaxLength);
    };
    
    this.setReadOnly = function(pReadOnly){
        this.TextBox.setReadOnly(pReadOnly);
    };
    
    this.setBSColumn = function(ln)
    {
        this.TextBox.setBSColumn(ln);
    };
    
    this.validateBlank = function(){
        if(this.TextBox.validateBlank()!==null)
            return this;
        else
            return null;
    };
    
    this.validateVTP = function(){
        if(this.TextBox.validateVTP()!==null)
            return this;
        else
            return null;
    };
    
    this.setTextValue = function(txt,vl)
    {
        this.setText(txt);
        this.setValue(vl);
    };
    
    this.setMaxLength = function(ln)
    {
        this.TextBox.setMaxLength(ln);
    };
    
    this.SearchAssignLocal = function(key,x)
    {
        var id = this.getID();
        var jsonObj = this.JSONData;
        for(var i=0;i<jsonObj.length;i++)
        {
            if(jsonObj[i][key]===x)
            {
                
                var tx = jsonObj[i][this.TextField];
                var vl = jsonObj[i][this.ValueField];
                
               
                this.setText(tx);
                this.setValue(vl);
                
                 try{
                    window[id+"_SearchAssign"](tx,vl,parent.Container);
                 }catch(e){};
            }
        }
    };
    
    this.SearchAssign = function(key,x)
    {
        var id = this.getID();
        var parent = this;
        this.Ajax.CallServer(function(data){
            
            var jsonObj = JSON.parse(data);
            
            for(var i=0;i<jsonObj.length;i++)
                if(jsonObj[i][key]===x){
                    var tx = jsonObj[i][parent.TextField];
                    var vl = jsonObj[i][parent.ValueField];
                    parent.setTextValue(tx,vl);
                    
                     try{
                        window[id+"_SearchAssign"](tx,vl,parent.Container);
                     }catch(e){};
                }
        });
        
    };
    
    this.GridViewRowSelected = function(idx){
        this.SelectRowIndex = idx;
//        alert(idx);
    };
    
    this.MatrixClick = function(json,rwi){
        this.setText(json[this.TextField]);
        this.setValue(json[this.ValueField]);
        $("#"+this.getID()).focus();
        
        this.DataSelected(json,rwi);
    };
    
};

function HC_AutoCompleteAjax(CTLName,pTextField,pValueField,pAjaxID,pSearchColumns,pGridViewColumns,pParentClassV)
{
    this.CTLName = CTLName || "";
    this.IsGridViewOpen = false;
    this.GridView = new HC_GridView(CTLName+"_Search",this);
    this.TextField = pTextField || "";
    this.ValueField = pValueField || "";
    this.JSONData = null;
    this.Text = "";
    this.Value = "";
    this.SelectRowIndex = -1;
    this.AjaxID = pAjaxID || "";
    this.SearchColumns = pSearchColumns || "";
    this.TextBox = new HC_BaseTextBox(CTLName,this);
    this.ParentClassV = pParentClassV || null;
    this.GridViewWidth = 500;
    this.GridViewHeight = 150;
    this.AjaxColumn = [];
    this.GridViewColumns = pGridViewColumns || null;
    this.Ajax = new HC_Ajax(pAjaxID);
    this.NextControl = null;
    this.Container = "";
    this.setText = function(txt)
    {
        this.Text = txt;
        this.TextBox.setText(txt);
    };
    
    this.setValue = function(txt)
    {
        this.Value = txt;
        this.TextBox.setValue(txt);
    };
    
    this.Dispose = function()
    {
        var id = this.Container + "_" + this.CTLName;
        
        this.TextBox.Dispose();
        
        $("#" + id + "_GridView").remove();
        $("#" + id + "_AutoCompleteContainer").remove();
    };
    
    this.clearAll = function()
    {
        var id = this.Container + "_" + this.CTLName;
        this.setText("");
        this.setValue("");
        $('#'+id).removeClass("is-valid");
        this.TextBox.setText("");
        this.TextBox.setValue("");
    };
    
    this.generateControlJQObject = function(CTLContainer)
    {
         this.Container = CTLContainer;
         var id = this.Container + "_" + this.CTLName;
         
         //alert(id);
         
         this.TextBox.generateControlJQObject(CTLContainer);
         
         var dv = $("#" + id + "_AutoCompleteContainer");
         dv.addClass("HC_AutoCompleContainer");
         var dvgrd = $("<div id='" + id + "_GridView' class='HC_AutoCompleGridView HC_AutoCompleItemContainer' style='background:white'></div>");
         dv.append(dvgrd);
         
         CTLContainer.append(dv);
         
         this.GridView.generateGridView(id+"_GridView");
         
         var ar = this.GridViewColumns.split(',');
         var i;
         for(i=0;i<ar.length;i++){
          this.GridView.AddColumn(ar[i],ar[i]);
         }
        
        this.GridView.setGridViewHeight(this.GridViewHeight);
        this.GridView.setGridViewWidth(this.GridViewWidth);
    };
    
    this.generateControl = function(CTLContainer)
    {
          this.Container = CTLContainer;
          var id = this.Container + "_" + this.CTLName;
         
         this.TextBox.generateControl(CTLContainer);
         
         var dv = $("#" + id + "_AutoCompleteContainer");
         dv.addClass("HC_AutoCompleContainer");
         var dvgrd = $("<div id='" + id + "_GridView' class='HC_AutoCompleGridView HC_AutoCompleItemContainer sticky-top' style='background:white'></div>");
         dv.append(dvgrd);
         
         $("#" + CTLContainer).append(dv); 
         
         $("#"+id+"_GridView").hide();
         
         this.GridView.generateGridView(id+"_GridView");
         
         var ar = this.GridViewColumns.split(',');
         var i;
         for(i=0;i<ar.length;i++){
          this.GridView.AddColumn(ar[i],ar[i]);
         }
        
        this.GridView.setGridViewHeight(this.GridViewHeight);
        this.GridView.setGridViewWidth(this.GridViewWidth);
    };
    
    this.TextBoxKeyUp = function(e,txt)
    {
        var parent = this;
        
        if(e.which === 13)
            this.gotoNextControl();
        
        if(e.which === 40 || e.which === 113){ 
                parent.OpenSearch(); 
        }
    };
    
    this.TextBoxKeyDown = function(e,txt)
    {
        if(e.which !== 40 && e.which !== 113 && e.which !== 9 && e.which !== 13){ 
            e.preventDefault();
        }
    };
    
    this.setGridViewColumnWidth = function(idx,CLWidth)
    {
        this.AjaxColumn.splice(idx,0,CLWidth);
    };
    
    this.SyncAjaxColumn = function() {
        var i;
        for(i=0;i<this.AjaxColumn.length;i++)
            this.GridView.setColumnWidth(i,this.AjaxColumn[i]);
    };
    
    this.OpenSearch = function()
    {
        var id = this.Container + "_" + this.CTLName;
        
        if(!this.IsGridViewOpen){
        
            this.Ajax.CMN_WhereCL = this.SearchColumns;
            this.Ajax.CMN_WhereData = "";
            var parent = this;
            
            this.Ajax.CallServer(function(data){
               
                $("#"+id+"_GridView").show();
                $("#"+id+"_GridView").width(parent.GridView.Width+30);
                $("#"+id+"_GridView").height(parent.GridView.Height);
                parent.GridView.FirstRowBlank=true;
                parent.GridView.clearHTMLRows();
                
                parent.GridView.AssginJSONToGridView(JSON.parse(data));

                if(parent.GridView.FirstRowBlank){  //add a blank data to json
                    var dt = JSON.parse(parent.GridView.getDataRow());
                    parent.GridView.data.matrix.splice(0,0,dt);
                }
                parent.GridView.AjaxColumnList = parent.GridViewColumns;
                parent.GridView.SyncJSONToGridView();
                parent.GridView.setSearching(true);
                parent.GridView.setDefaultWidth(false);
                parent.IsGridViewOpen = true;
                parent.GridView.setScrollBarX(true);
                parent.GridView.setScrollBarY(true);
                parent.GridView.setFocusOnSearch();
                parent.GridView.AjaxEnable = true;
                parent.GridView.AjaxID = parent.AjaxID;
                parent.GridView.AjaxSearchColumns = parent.SearchColumns;

                if(parent.Value!==""){
                    parent.GridView.focusRowSearch(parent.ValueField,parent.Value);
                }
                
                parent.GridView.defineEvents();

                $("#"+id+"_Search_search").focusout(function(){
                    parent.CloseSearchDelay();
                });
                
                
                try{
                    this.ParentClassV.HC_AutoCompleteAjax_OpenSearch();
                }catch(e){} 

                try{
                    window[id+"_OpenSearch"]();
                }catch(e){};
                
            });
        }
    };
    
    this.DataSelected = function(rwjson,rwi)
    {
        var id = this.Container + "_" + this.CTLName;
        
        if(rwi>=0){
            if(this.ValueField!=="")
                this.setValue(rwjson[this.ValueField]);

            if(this.TextField!==""){
                this.setText(rwjson[this.TextField]);
                this.setValue(rwjson[this.ValueField]);
            }

            this.SelectRowIndex = rwi;

            try{
                window[id+"_DataSelected"](rwjson,rwi);
            }catch(e){}
            
            try{
                this.ParentClassV.HC_AutoCompleteAjax_DataSelected(rwjson,rwi);
            }catch(e){} 
            
        }
        else{
            alert("Data Not Found . . .");
        }
        this.CloseSearch();
    };
    
    this.CloseSearch = function(x)
    {
        var id = this.Container + "_" + this.CTLName;
        //$("#"+id+"_GridView").html("");
        this.IsGridViewOpen = false;
        $("#"+id+"_GridView").hide();
        if(x===undefined)
            $("#"+id).focus();
        
        try{
            this.ParentClassV.HC_AutoCompleteAjax_CloseSearch();
        }catch(e){} 
        
        try{
            window[id+"_CloseSearch"]();
        }catch(e){};
    };
    
    this.CloseSearchDelay = function()
    {
        var parent = this;
        var tm;
        tm = setInterval(function() {
            parent.CloseSearch('Abnormal');
            clearInterval(tm);
        },400);
    };
    
    this.EscapePressed = function()
    {
        this.CloseSearch();
    };
    
    this.setGridViewHeight = function(height){
        var id = this.Container + "_" + this.CTLName;
        this.GridViewHeight = height;
        if(this.GridView!==null){
            this.GridView.setGridViewHeight(height);
        }
        $("#"+id+"_GridView").css("height",height+2);
    };
    
    this.setGridViewWidth = function(width){
        this.GridViewWidth = width;
        var id = this.Container + "_" + this.CTLName;
        if(this.GridView!==null){
            this.GridView.setGridViewWidth(width);
        }
        $("#"+id+"_GridView").css("width",width+2);
    };
    
    this.setFocus = function(){
        this.TextBox.setFocus();
    };
    
    this.gotoNextControl = function()
    {
        var id = this.Container + "_" + this.CTLName;
        if(this.NextControl!==null)
        {
            try{
                this.NextControl.setFocus();
            }catch(e){};
            
            try{
                window[id+"_gotoNextControl"](id,this.NextControl);
            }catch(e){};
            
            try{
                if(this.ParentClassV!==null){
                    this.ParentClassV.gotoNextControl(id,this.NextControl);
                }
            }catch(e){};
        }
    };
      
    this.setLabel = function(pLabel)
    {
        this.TextBox.setLabel(pLabel);
    };
    
    this.setShowLabel = function(tf)
    {
        this.TextBox.setShowLabel(tf);
    };
    
    this.setPlaceHolder = function(pPlaceHolder)
    {
        this.TextBox.setPlaceHolder(pPlaceHolder);
    };
    
    this.setValidationType = function(pValidationType)
    {
        this.TextBox.setValidationType(pValidationType);
    };
    
    this.setMaxLength = function(pMaxLength){
        this.TextBox.setMaxLength(pMaxLength);
    };
    
    this.setReadOnly = function(pReadOnly){
        this.TextBox.setReadOnly(pReadOnly);
    };
    
    this.setBSColumn = function(ln)
    {
        this.TextBox.setBSColumn(ln);
    };
    
    this.validateBlank = function(){
        if(this.TextBox.validateBlank()!==null)
            return this;
        else
            return null;
    };
    
    this.validateVTP = function(){
        if(this.TextBox.validateVTP()!==null)
            return this;
        else
            return null;
    };
    this.setTextValue = function(txt,vl)
    {
        this.setText(txt);
        this.setValue(vl);
    };
    
    this.setMaxLength = function(ln)
    {
        this.TextBox.setMaxLength(ln);
    };
};

function HC_DatePicker(CTLName,pParentClassV)
{
    this.CTLName = CTLName || "";
    this.IsDatePickerOpen = false;
    this.DatePicker = null;
    this.Text = "";
    this.Value = "";
    this.Calender = new HC_Calender(this.CTLName+"_Calender",this);
    this.SelectedDate = new HC_Date();
    this.TextBox = new HC_BaseTextBox(this.CTLName,this);
    this.showYear = false;
    this.showMonth = false;
    this.ParentClassV = pParentClassV || null;
    this.NextControl = null;
    this.Container = "";
    this.tempTXT = "";
    this.ChangeButtonActive = false;
    this.tm = null;
    this.AutoPopUP = true;
    
    this.setBackColor = function(Color){
       this.TextBox.setBackColor(Color);
    };
    
    this.getBackColor = function(){
        return this.TextBox.getBackColor();
    };
    
    this.ChangeDateClick = function(tp){
        var id = this.getID();
        this.ChangeButtonActive = true;
        
        //alert(this.ChangeButtonActive);
        //this.TextBox.setFocus();
    };
    
    this.getID = function()
    {
        if(this.Container!=="")
            return this.Container + "_" + this.CTLName;
        else
            return this.CTLName;
    };
    
    this.setText = function(txt)
    {
        this.Text = txt;
        this.TextBox.setText(txt);
    };
    
    this.setValue = function(txt)
    {
        this.Value = txt;
        this.TextBox.setValue(txt);
    };
    
    this.clearAll = function()
    {
        var id = this.getID();
        this.setText("");
        this.setValue("");
        $('#'+id).removeClass("is-valid");
        this.TextBox.setText("");
        this.TextBox.setValue("");
    };
    
    this.Dispose = function()
    {
        //var id = this.getID();
        
        this.TextBox.Dispose();
        
        this.Calender.Dispose();
       
    };
    
    this.TextBoxKeyUp = function(e,txt)
    {
        var parent = this;
        if(e.which === 13)
        {
            parent.SelectedDate = parent.Calender.Date;
            parent.DateSelected();
            this.gotoNextControl();
        }
        if(e.which===40 || e.which === 113) //Bottom
        {
            if(!this.IsDatePickerOpen)
                this.OpenDatePicker();
        }
        else
        if(e.which === 27)
        {
            parent.CloseDatePicker();
        }
        else
        if(txt.length===10)
        {
            if(this.tempTXT!==txt)
                parent.ProcessYearDay(txt);
        }
        
    };
    
    this.TextBoxKeyDown = function(e,txt)
    {
        this.tempTXT = txt;
        
        if(e.altKey)
        {
            if(e.which===37) //Left
            {
                this.prevMonth();
                e.preventDefault();
            }
            else
            if(e.which===39) //Right
            {
                this.nextMonth();
                e.preventDefault();
            }
        }
        else
        if(window.event.ctrlKey)
        {
            if(e.which===37) //Left
            {
                this.prevYear();
                e.preventDefault();
            }
            else
            if(e.which===39) //Right
            {
                this.nextYear();
                e.preventDefault();
            }
        }   
        else{
            if(e.which===37) //Left
            {
                this.prevDay();
                e.preventDefault();
            }
            else
            if(e.which===39) //Right
            {
                this.nextDay();
                e.preventDefault();
            }
        }
        if(e.which===38) //Top
        {
            this.prevWeek();
            e.preventDefault();
        }
        else
        if(e.which===40 || e.which === 113) //Bottom
        {
            if(this.IsDatePickerOpen){
                this.nextWeek();
                e.preventDefault();
            }
        }
    };
    
    this.setupAdditional = function()
    {
         var id = this.getID();
         
          var parent = this;
         
          /*$("#" + id).unbind("keydown");
             $("#" + id).keydown(function(e){ 
                tl = $(this).val().length;
            });*/
            
            $("#" + id).unbind("focusout");
            $("#" + id).focusout(function(){
                parent.CloseSearchDelay();
            });
         
            $("#" + id).unbind("focus");
            $("#" + id).focus(function(){
                if(parent.AutoPopUP){
                    if(!parent.IsDatePickerOpen){
                        parent.OpenDatePicker();
                    }
                }
            });
    };
    
    this.generateControl = function(CTLContainer)
    {
         this.Container = CTLContainer || "";
        
         this.TextBox.generateControl(CTLContainer);
         
         var id = this.getID();
         
         var dv = $("#" + id + "_container");
         dv.addClass("HC_AutoCompleContainer");
         var dvgrd = $("<div id='" + id + "_CalenderContainer' class='HC_AutoCompleGridView HC_DatePickerItemContainer'></div>");
         dv.append(dvgrd);
         
         $("#" + CTLContainer).append(dv);
         
         $("#" + id).mask("00.00.0000");
         
         try{
         this.Calender.generateControlJQObject(dvgrd);
         }catch(e){
             alert(e);
         }
         this.Calender.hideCalender();
         
         this.setupAdditional();
         
    };
    
    
    this.generateControlJQObject = function(CTLContainer)
    {
         var id = this.getID();
         
         this.TextBox.generateControlJQObject(CTLContainer);
         
         var dv = $("#" + id + "_container");
         dv.addClass("HC_AutoCompleContainer");
         var dvgrd = $("<div id='" + id + "_GridView' class='HC_AutoCompleGridView HC_DatePickerItemContainer'></div>");
         dv.append(dvgrd);
         
         CTLContainer.append(dv);
         
         $("#" + id).mask("00.00.0000");
         
         try{
         this.Calender.generateControlJQObject(dvgrd);
         }catch(e){
             alert(e);
         }
         this.Calender.hideCalender();
         
         this.setupAdditional();
         
    };
    
    this.OpenDatePicker = function()
    {
        try{
        var id = this.getID();
        var parent = this;
        var tl;
        
        if(!this.IsDatePickerOpen){
            
            this.Calender.showCalender();
            
            this.IsDatePickerOpen = true;
            
            
            try{
                window[id+"_OpenDatePicker"]();
            }catch(e){};
            
            try{
                if(this.ParentClassV!==null){
                    this.ParentClassV.OpenDatePicker();
                }
            }catch(e){};
            
        }
        
        }catch(ee){alert(ee);}
    };
    
    this.ProcessYearDay = function(x)
    {
        if(x.length===10)
        {
            if(this.SelectedDate.ValidateUIDate(x)){
                this.Calender.Date.setDate(x);
                this.SelectedDate = this.Calender.Date;
                this.Calender.LoadMonthData();
            }
            else{
                alert("Invalid Date Format (dd.mm.yyyy)");
            }
        }
    };
    
    this.nextDay = function()
    {
        var id = this.getID();
        
        this.Calender.nextDay();
        
        try{
            window[id+"_NextDay"](cdt,ndt);
        }catch(e){};
            
        try{
            this.ParentClassV.DatePicker_NextDay(cdt,ndt);
        }catch(e){};
       
    };
    
    this.prevDay = function()
    {
        var id = this.getID();
        
        this.Calender.prevDay();
        
         try{
            window[id+"_PrevDay"](cdt,ndt);
        }catch(e){};
            
        try{
            this.ParentClassV.DatePicker_PrevDay(cdt,ndt);
        }catch(e){};
        
        
    };
    
    this.nextWeek = function()
    {
        var id = this.getID();
        
        this.Calender.nextWeek();
        
         try{
            window[id+"_NextWeek"](cdt,ndt);
        }catch(e){};
            
        try{
            this.ParentClassV.DatePicker_NextWeek(cdt,ndt);
        }catch(e){};

    };
    
    this.prevWeek = function()
    {
        var id = this.getID();
        
        this.Calender.prevWeek();
        
         try{
            window[id+"_PrevWeek"](cdt,ndt);
        }catch(e){};
            
        try{
            this.ParentClassV.DatePicker_PrevWeek(cdt,ndt);
        }catch(e){};
        
        this.LoadMonthData();
    };
    
    this.nextMonth = function()
    {
        var id = this.getID();
        
        this.Calender.nextMonth();
        
         try{
            window[id+"_NextMonth"](cdt,ndt);
        }catch(e){};
            
        try{
            this.ParentClassV.DatePicker_NextMonth(cdt,ndt);
        }catch(e){};
        
    };
    
    this.prevMonth = function()
    {
        var id = this.getID();
        
        this.Calender.prevMonth();
        
         try{
            window[id+"_PrevMonth"](cdt,ndt);
        }catch(e){};
            
        try{
            this.ParentClassV.DatePicker_PrevMonth(cdt,ndt);
        }catch(e){};
        
        this.LoadMonthData();
    };
    
    this.nextYear = function()
    {
        var id = this.getID();
        
        this.Calender.nextYear();
        
         try{
            window[id+"_NextYear"](cdt,ndt);
        }catch(e){};
            
        try{
            this.ParentClassV.DatePicker_NextYear(cdt,ndt);
        }catch(e){};
        
    };
    
    this.prevYear = function()
    {
        var id = this.getID();
        
        this.Calender.prevYear();
        
         try{
            window[id+"_PrevYear"](cdt,ndt);
        }catch(e){};
            
        try{
            this.ParentClassV.DatePicker_PrevYear(cdt,ndt);
        }catch(e){};
        
    };
    
    this.HC_Calender_DateSelected = function(x,dt){
        this.SelectedDate = dt;
        this.DateSelected();
    };
    
    this.DateSelected = function()
    {
        var id = this.getID();
        this.setValue(this.SelectedDate.getUIDate());
        this.setText(this.SelectedDate.getUIDate());
        
        //alert("Ssss");
        this.TextBox.setFocus();
        
        try{
            window[id+"_DateSelected"](this.Text);
        }catch(e){}
        
        try{
            this.ParentClassV.HC_DatePicker_DateSelected(this.Text,this.SelectedDate);
        }catch(e){} 
        
        this.CloseDatePicker();
    };
  
    this.CloseDatePicker = function(x)
    {
        var id = this.getID();
        
        this.Calender.hideCalender();
        
        this.IsDatePickerOpen = false;
        
        this.ChangeButtonActive = false;
        
        try{
            window[id+"_CloseDatePicker"]();
        }catch(e){};

        try{
            if(this.ParentClassV!==null){
                this.ParentClassV.CloseDatePicker();
            }
        }catch(e){};
    };
    
    this.CloseSearchDelay = function()
    {
        var parent = this;
        var id = this.getID();
        
        /*
        (new HC_Ajax("acDelay")).CallServer(function(){
            //alert(parent.ChangeButtonActive);
            if(!parent.ChangeButtonActive)
                parent.CloseDatePicker('Abnormal');
            else{
                //parent.TextBox.setFocus();
                parent.ChangeButtonActive=false;
                $("#"+id).focus();
            }
        });*/
    };
    
    this.setFocus = function(){
        this.TextBox.setFocus();
    };
    
    this.gotoNextControl = function()
    {
        var id = this.getID();
        if(this.NextControl!==null)
        {
            try{
                this.NextControl.setFocus();
            }catch(e){}
            
            try{
                window[id+"_gotoNextControl"](id,this.NextControl);
            }catch(e){};
            
            try{
                if(this.ParentClassV!==null){
                    this.ParentClassV.gotoNextControl(id,this.NextControl);
                }
            }catch(e){alert(e);};
        }
    };
    
    this.setLabel = function(pLabel)
    {
        this.TextBox.setLabel(pLabel);
    };
    
    this.setShowLabel = function(tf)
    {
        this.TextBox.setShowLabel(tf);
    };
    
    this.setPlaceHolder = function(pPlaceHolder)
    {
        this.TextBox.setPlaceHolder(pPlaceHolder);
    };
    
    this.setValidationType = function(pValidationType)
    {
        this.TextBox.setValidationType(pValidationType);
    };
    
    this.setMaxLength = function(pMaxLength){
        this.TextBox.setMaxLength(pMaxLength);
    };
    
    this.setReadOnly = function(pReadOnly){
        this.TextBox.setReadOnly(pReadOnly);
    };
    
    this.setBSColumn = function(ln)
    {
        this.TextBox.setBSColumn(ln);
    };
    
    this.validateBlank = function(){
        if(this.TextBox.validateBlank()!==null)
            return this;
        else
            return null;
    };
    
    this.validateVTP = function(){
        if(this.TextBox.validateVTP()!==null)
            return this;
        else
            return null;
    };
    
    this.setTextValue = function(txt,vl)
    {
        this.setText(txt);
        this.setValue(vl);
    };
    
    this.setMaxLength = function(ln)
    {
        this.TextBox.setMaxLength(ln);
    };
};

function HC_AutoCheckBoxJSON(CTLName,pTextField,pValueField,pColumns,pJSON,pParentClassV)
{
    this.CTLName = CTLName || "";
    this.IsGridViewOpen = false;
    this.GridView =  new HC_GridView(CTLName+"_Search",this);
    this.TextField = pTextField || "";
    this.ValueField = pValueField || "";
    this.Columns = pColumns || "";
    this.JSONData = pJSON;
    this.Text = "";
    this.Value = "";
    this.SelectRowIndex = -1;
    this.TextBox = new HC_BaseTextBox(CTLName,this);
    this.ParentClassV = pParentClassV || null;
    this.GridViewWidth = 500;
    this.GridViewHeight = 150;
    this.Ajax = new HC_Ajax();
    this.CheckBoxClicked = false;
    this.CurrentSelRow = -1;
    this.NextControl = null;
    this.Container = "";
    
    this.setText = function(txt)
    {
        this.Text = txt;
        this.TextBox.setText(txt);
    };
    
    this.setValue = function(txt)
    {
        this.Value = txt;
        this.TextBox.setValue(txt);
    };
    
    this.Dispose = function()
    {
        var id = this.Container + "_" + this.CTLName;
        
        this.TextBox.Dispose();
        
        $("#" + id + "_GridView").remove();
        $("#" + id + "_AutoCompleteContainer").remove();
    };
    
    this.clearAll = function()
    {
        this.setText("");
        this.setValue("");
        $('#'+this.CTLName).removeClass("is-valid");
        this.TextBox.setText("");
        this.TextBox.setValue("");
    };
    
    this.TextBoxKeyUp = function(e,txt)
    {
        var parent = this;
        
        if(e.which===13)
        {
            this.gotoNextControl();
        }
        
        if(e.which === 40 || e.which === 113){ 
                parent.OpenSearch(); 
        }
    };
    
    this.TextBoxKeyDown = function(e,txt)
    {
        if(e.which !== 40 && e.which !== 113 && e.which !== 9 && e.which !== 13){ 
            e.preventDefault();
        }
    };
    
    this.GridViewFocusRow = function(idx){
        this.CurrentSelRow = idx;
    };
    
    this.generateControl = function(CTLContainer)
    {
         this.Container = CTLContainer;
         var id = this.Container + "_" + this.CTLName;
         var parent = this;
         
         this.TextBox.generateControl(CTLContainer);
         
         var dv = $("#" + id + "_AutoCompleteContainer");
         dv.addClass("HC_AutoCompleContainer");
         var dvgrd = $("<div id='" + id + "_GridView' class='HC_AutoCompleGridView HC_AutoCompleItemContainer'></div>");
         dv.append(dvgrd);
         
         $("#" + CTLContainer).append(dv);
         
         //$('#'+id).focusin(function(){ try{ parent.OpenSearch(); }catch(e){alert(e);} });         
         
            var jsonString = JSON.stringify(this.JSONData);
            this.GridView.FirstRowBlank=true;  
             
            this.GridView.Create(id+"_GridView");
            
            alert("Sesss");
            //Adding Colummns Start
                var ar = this.Columns.split(',');
                this.GridView.AddColumn('','');
                this.GridView.setColumnWidth(0,25);
                
                for(i=0;i<ar.length;i++)
                    this.GridView.AddColumn(ar[i],ar[i]);
            //Adding Columns End
            
            if(this.JSONData!==null)
            {
               
                this.populateUsingJSON(jsonString);
            }
            
            this.GridView.setSearching(true);
            this.GridView.setDefaultWidth(false);
            this.GridView.setGridViewWidth(this.GridViewWidth);
            this.IsGridViewOpen = true;
            this.GridView.setScrollBarX(true);
            this.GridView.setScrollBarY(true);
            this.GridView.setGridViewHeight(this.GridViewHeight);
            if(this.SelectRowIndex>=0)
                this.GridView.focusRow(this.SelectRowIndex);
            this.GridView.defineEvents();

             this.setGridViewHeight(this.GridViewHeight);
             this.setGridViewWidth(this.GridViewWidth);
             
             $("#"+id+"_GridView").hide();

            $("#"+id+"_Search_search").focusout(function(){
                parent.CloseSearchDelay();
            }); 
            
            $("#"+id+"_Search_search").keyup(function(e){
                if(e.which === 119){ 
                    var chk = $("." + id + "_chkClass").eq(parent.CurrentSelRow);
                    if(!chk.prop("checked"))
                        chk.prop("checked",true);
                    else
                        chk.prop("checked",false);
                    
                    try{
                        this.ParentClassV.HC_AutoCompleteJSON_CheckBoxSelect(parent.CurrentSelRow,chk.prop("checked"));
                    }catch(e){} 

                    try{    
                        window[id+"_CheckBoxSelect"](parent.CurrentSelRow,chk.prop("checked"));
                    }catch(e){};
                }
            });
            
    };
    
    this.OpenSearch = function()
    {
        var id = this.Container + "_" + this.CTLName;
        
        var parent = this;
        
        $("#"+id+"_GridView").show();
        
        this.GridView.setFocusOnSearch();
        
        if(this.SelectRowIndex>=0){
            this.GridView.SearchGRID('');
            this.GridView.focusRow(this.SelectRowIndex);
        }
        
        this.IsGridViewOpen = true;
        
        try{
            this.ParentClassV.HC_AutoCheckBoxJSON_OpenSearch();
        }catch(e){} 

        try{
            window[id+"_OpenSearch"]();
        }catch(e){};
    };
    
    this.DataSelected = function(rwjson,rwi)
    {
        var id = this.Container + "_" + this.CTLName;
        
        if(rwi>=0){
            
            if(this.TextField!==""){
                var txt = "",vl = "";
                for(i=0;i<$("."+id+"_chkClass").length;i++){
                    var chk = $("."+id+"_chkClass").eq(i);
                    if(chk.prop("checked")){
                        txt += "," + this.GridView.getJSONMatrix(i)[this.TextField];
                        vl += "," + this.GridView.getJSONMatrix(i)[this.ValueField];
                    }
                }
                if(txt!==""){
                    txt = txt.substring(1);
                    vl = vl.substring(1);
                }
                $("#"+id).val(txt);
                this.Text = rwjson[txt];
                this.Value = rwjson[vl];
            }

            this.SelectRowIndex = rwi;

            try{
            window[id+"_DataSelected"](rwjson,rwi);
            }catch(e){}
            
            try{
                this.ParentClassV.HC_AutoCheckBoxJSON_DataSelected(rwjson,rwi);
            }catch(e){} 
            
        }
        else{
            alert("Data Not Found . . .");
        }
        this.CloseSearch();
    };
    
    this.CloseSearch = function(x)
    {
        var id = this.Container + "_" + this.CTLName;
        this.IsGridViewOpen = false;
        $("#"+id+"_GridView").hide();
        if(x===undefined)
            $("#"+id).focus();
        
        try{
            this.ParentClassV.HC_AutoCheckBoxJSON_CloseSearch();
        }catch(e){} 

        try{
            window[id+"_CloseSearch"]();
        }catch(e){};
        
    };
    
    this.CloseSearchDelay = function()
    {
        var parent = this;
        var tm;
        tm = setInterval(function() {
            if(parent.CheckBoxClicked)
                parent.CheckBoxClicked=false;
            else
                parent.CloseSearch('Abnormal');
            clearInterval(tm);
        },400);
    };
    
    this.EscapePressed = function()
    {
        this.CloseSearch();
    };
    
    this.setGridViewHeight = function(height){
        var id = this.Container + "_" + this.CTLName;
        this.GridViewHeight = height;
        if(this.GridView!==null){
            this.GridView.setGridViewHeight(height);
        }
        
        $("#"+id+"_GridView").css("height",height+2);
    };
    
    this.setGridViewWidth = function(width){
        this.GridViewWidth = width;
        var id = this.Container + "_" + this.CTLName;
        if(this.GridView!==null){
            this.GridView.setGridViewWidth(width);
        }
        $("#"+id+"_GridView").css("width",width+2);
    };
    
    this.addRows = function(vl,txt,idx)
    {
        var id = this.Container + "_" + this.CTLName;
        
        if(idx===undefined){
            this.GridView.addRow();
            var li = this.GridView.getRowLength() - 1;
            this.GridView.setHTML(li,this.GridView.getColumnIndex(this.ValueField),vl);
            this.GridView.setHTML(li,this.GridView.getColumnIndex(this.TextField),txt);
        }
        else{
            this.GridView.addRow(idx);
            this.GridView.setHTML(idx,this.GridView.getColumnIndex(this.ValueField),vl);
            this.GridView.setHTML(idx,this.GridView.getColumnIndex(this.TextField),txt);
        }
        
        try{
            this.ParentClassV.HC_AutoCheckBoxJSON_AddRow(vl,txt,idx);
        }catch(e){} 
        
        try{
            window[id+"_AddRow"](vl,txt,idx);
        }catch(e){};
        
    };
    
    this.removeRow = function(idx)
    {
        var id = this.Container + "_" + this.CTLName;
        if(idx<this.GridView.getRowLength())
        {
            this.GridView.removeRow(idx);
        }
        
        try{
            this.ParentClassV.HC_AutoCheckBoxJSON_RemoveRow(idx);
        }catch(e){} 

        try{    
            window[id+"_AddRow"](idx);
        }catch(e){};
    };
    
    this.removeRowAll = function()
    {
        this.GridView.clearAllRows();
    };
    
    this.populateUsingJSON = function(data,Append)
    {
        var json = new HC_Json(data);
        var i,j;
        var ar = this.Columns.split(',');
        var stpt = 0;
        if(Append===true)
            var stpt = this.GridView.getRowLength();
            
        for(i=stpt;i<stpt+json.getArRowLength();i++){
            this.GridView.addRow();
            for(j=0;j<ar.length;j++)
            {   
                var ci = this.GridView.getColumnIndex(ar[j]);
                this.GridView.setHTML(i,ci,json.getArVK((i-stpt),ar[j]));
            }
        }
    };
    
    this.populatefromAjax = function(AjaxID,WhereCL,Append){
        this.Ajax.AjaxID = AjaxID;
        this.Ajax.CMN_WhereCL = WhereCL;
        this.Ajax.CMN_WhereData = '';
        var parent = this;
        this.Ajax.CallServer(function(data){
            alert(data);
            parent.populateUsingJSON(data);
        });
    };
    
    this.GridViewAddRow = function(pos)
    {
        var id = this.Container + "_" + this.CTLName;
        this.GridView.setHTML(pos,0,"<input type='checkbox' style='margin-top:3px' class='" + this.CTLName +"_chkClass' />");
        
        var parent = this;
        
        $("."+id+"_chkClass").click(function(){
            parent.CheckBoxClicked = true;
            $("#"+id+"_Search_search").focus();
        });
    };
    
    this.setFocus = function(){
        this.TextBox.setFocus();
    };
    
    this.gotoNextControl = function()
    {
        var id = this.Container + "_" + this.CTLName;
        if(this.NextControl!==null)
        {
            try{
                this.NextControl.setFocus();
            }catch(e){}
            
            try{
                window[id+"_gotoNextControl"](this.CTLName,this.NextControl);
            }catch(e){};
            
            try{
                if(this.ParentClassV!==null){
                    this.ParentClassV.gotoNextControl(this.CTLName,this.NextControl);
                }
            }catch(e){};
        }
    };
    
    this.RemoveControl = function()
    {
        var id = this.Container + "_" + this.CTLName;
        $("#"+id+ "_container").remove();
    };
    
    this.setLabel = function(pLabel)
    {
        this.TextBox.setLabel(pLabel);
    };
    
    this.setShowLabel = function(tf)
    {
        this.TextBox.setShowLabel(tf);
    };
    
    this.setPlaceHolder = function(pPlaceHolder)
    {
        this.TextBox.setPlaceHolder(pPlaceHolder);
    };
    
    this.setValidationType = function(pValidationType)
    {
        this.TextBox.setValidationType(pValidationType);
    };
    
    this.setMaxLength = function(pMaxLength){
        this.TextBox.setMaxLength(pMaxLength);
    };
    
    this.setReadOnly = function(pReadOnly){
        this.TextBox.setReadOnly(pReadOnly);
    };
    
    this.setBSColumn = function(ln)
    {
        this.TextBox.setBSColumn(ln);
    };
    
    this.validateBlank = function(){
        if(this.TextBox.validateBlank()!==null)
            return this;
        else
            return null;
    };
    
    this.validateVTP = function(){
        if(this.TextBox.validateVTP()!==null)
            return this;
        else
            return null;
    };
    
    this.setTextValue = function(txt,vl)
    {
        this.setText(txt);
        this.setValue(vl);
    };
    
    this.setMaxLength = function(ln)
    {
        this.TextBox.setMaxLength(ln);
    };
};

function HC_Select(CTLName,pJSON,pParentClassV)
{
    this.CTLName = CTLName || "";
    this.json = pJSON || [];
    this.Text = "";
    this.Value = "";
    this.SelectedIndex = -1;
    this.Select = new HC_BaseSelect(CTLName,this);
    this.ParentClassV = pParentClassV || null;
    this.Ajax = new HC_Ajax();
    
    this.getID = function()
    {
        if(this.Container!=="")
            return this.Container + "_" + this.CTLName;
        else
            return this.CTLName;
    };
    
    this.generateControl = function(CTLContainer,pCTLName)
    {
         this.Select.generateControl(CTLContainer,pCTLName);
         if(this.json!==null && this.json.length>0)
         {
            this.populateUsingJSON();
         }
         
    };
    
    this.generateControlJQObject = function(CTLContainer,pCTLName)
    {
         this.Select.generateControlJQObject(CTLContainer,pCTLName);
         if(this.json!==null && this.json.length>0)
         {
            this.populateUsingJSON();
         }
    };
    
    this.Dispose = function()
    {
        this.Select.Dispose();
    };
    
    this.HC_BaseSelect_DataSelected = function(txt,vl,idx)
    {
        var id = this.getID();
        this.Text = txt;
        this.Value = vl;
        this.SelectedIndex = idx;
        
        try{
            window[id+"_Select"](txt,vl,idx);
        }catch(e){}

        try{
            this.ParentClassV.HC_Select_DataSelected(txt,vl,idx);
            //The following functions used call parent 
        }catch(e){} 
    };
    
    this.setText = function(txt)
    {
        this.Select.setText(txt);
        this.Text = txt;
        this.Select.Text = txt;
    };
    
    this.setValue = function(vl)
    {
        this.Value = vl;
        this.Select.Value = vl;
    };
    
    this.addValue = function(vl,txt,pos)
    {
        var jsStr = '{"id":"' + vl + '","value":"' + txt + '"}';
        
        if(pos===undefined){
            this.json.push(JSON.parse(jsStr));
        }
        else{
            this.json.splice(pos,0,JSON.parse(jsStr));
        }
    };
    
    this.addRow = function(vl,txt,pos)
    {
        var id = this.getID();
        var liref = null;
        var liobj = "<option>" + txt + "</option>";
        if(pos===undefined){
            $("#"+this.CTLName).append(liobj);
        }
        else{
            if(pos<this.json.length)
            {
                liref = $("#"+this.CTLName+" option").eq(pos);
                if(pos===0)
                    liref.before(liobj);
                else
                    liref.append(liobj);
            }
            else
                $("#"+this.CTLName).append(liobj);
        }
        this.addValue(vl,txt,pos);
        
        try{
            this.ParentClassV.HC_Select_AddRow(vl,txt,pos);
        }catch(e){} 
        
        try{
            window[id+"_AddRow"](vl,txt,pos);
        }catch(e){};
    };
    
    this.removeRow = function(pos)
    {
        var id = this.Container + "_" + this.CTLName;
        
        if(pos<this.json.length){
            this.json.splice(pos,1);
            $("#"+id+" option").eq(pos).remove();
        }
        
        try{
            this.ParentClassV.HC_Select_RemoveRow(pos);
        }catch(e){} 
        
        try{
            window[id+"_RemoveRow"](pos);
        }catch(e){};
    };
    
    this.removeRowAll = function()
    {
        var id = this.getID();
        this.json = [];
        $("#"+id).html("");
    };
    
    this.populateUsingJSON = function(data,Append)
    {
        var json = new HC_Json(data);
        var i,j;
        var stpt = 0;
        if(Append===true)
            var stpt = this.json.length;
            
        for(i=stpt;i<stpt+json.getArRowLength();i++){
            this.addRow(json.getArVI(i-stpt,0),json.getArVI(i-stpt,1));
        }
    };
    
    this.populatefromAjax = function(AjaxID,WhereCL,Append){
        this.Ajax.AjaxID = AjaxID;
        this.Ajax.CMN_WhereCL = WhereCL;
        this.Ajax.CMN_WhereData = '';
        var parent = this;
        this.Ajax.CallServer(function(data){
            if(Append===false || Append===undefined){
                parent.removeRowAll();
                parent.populateUsingJSON(data,false);
            }
            else{
                parent.populateUsingJSON(data,true);
            }
        });
    };
    
    this.setFocus = function(){
        this.TextBox.setFocus();
    };
    
    this.gotoNextControl = function()
    {
        var id = this.getID();
        if(this.NextControl!==null)
        {
            try{
            this.NextControl.setFocus();
            }catch(e){}
            
            try{
                window[id+"_gotoNextControl"](id,id);
            }catch(e){};
            
            try{
                if(this.ParentClassV!==null){
                    this.ParentClassV.gotoNextControl(id,id);
                }
            }catch(e){};
        }
    };
    
    this.setTextValue = function(txt,vl)
    {
        this.setText(txt);
        this.setValue(vl);
    };
    
    this.setIndex = function(idx)
    {
        this.SelectedIndex = idx;
        var txt = this.json[idx].value;
        $("#"+this.CTLName).val(txt);
    };
    
    this.setMaxLength = function(ln)
    {
        
    };
};

function HC_CheckBox(CTLName,pJSON,pParentClassV)
{
    this.CTLName = CTLName || "";
    this.json = pJSON || [];
    this.Text = "";
    this.Value = "";
    this.Label = new HC_Label(this.CTLName+"_label");
    this.SelectedIndex = -1;
    this.ParentClassV = pParentClassV || null;
    this.Ajax = new HC_Ajax();
    this.ShowLabel = true;
    this.NextControl = null;
    this.BSColumn = "";
    this.Container = "";
    this.generateControl = function(CTLContainer)
    {
         this.Container = CTLContainer;
         var id = this.Container + "_" + this.CTLName;
         var dv = $("<div id='" + id + "_CheckBoxContainer'></div>");
         var chHidden = $("<input id='" + id + "' type='hidden' />");
         dv.append(chHidden);
         var dvctl = $("<div id='" + id + "_control'></div>");
         dv.append(dvctl);
         
         this.Label.generateControlJQObject(dvctl);
         
         var errmsg = "<div id='" + id + "_ermsg'></div>";
         dv.append(errmsg);
         
         $("#" + CTLContainer).append(dv);
         
         if(this.json!==null && this.json.length>0)
         {
            var tjson = JSON.stringify(this.json);
            this.json = [];
            this.populateUsingJSON(tjson);
         }
    };
    
    this.Dispose = function()
    {
        this.removeAllCheckBox();
        var id = this.Container + "_" + this.CTLName;
        $("#" + id + "_ermsg").remove();
        $("#" + id + "_control").remove();
        $("#" + id).remove();
        $("#" + id + "_CheckBoxContainer").remove();
    };
    
    this.setLabel = function(pLabel)
    {
        this.Label.setLabel(pLabel);
    };
    
    this.setShowLabel = function(tf)
    {
        this.Label.setShowLabel(tf);
    };
    
    this.generateControlJQObject = function(CTLContainer)
    {
         this.Select.generateControlJQObject(CTLContainer);
    };
    
    this.setText = function(txt)
    {
        var id = this.Container + "_" + this.CTLName;
        $('#'+id).val(txt);
        this.Text = txt;
        if(txt!==""){
            var ar = txt.split(',');
            for(var chi=0;chi<ar.length;chi++)
                this.checkRadio(ar[chi],"Text");
        }
    };
    
    this.checkRadio = function(txt,vlTP)
    {
        //$("."+this.CTLName+"_Radio").prop("checked",false);
        var cobj = $("."+this.CTLName+"_CheckBox");
        var lobj = $("."+this.CTLName+"_Label");
        for(var ci=0;ci<cobj.length;ci++)
        {
            var chk = cobj.eq(ci);
            if(vlTP==="Text"){
                if(txt===chk.val())
                    chk.prop("checked",true);
            }
            if(vlTP==="Value"){
                if(txt===lobj.eq(ci).html())
                    chk.prop("checked",true);
            }
        }
    };
    
    this.setValue = function(txt)
    {
        this.Value = txt;
        if(txt!==""){
            var ar = txt.split(',');
            for(var chi=0;chi<ar.length;chi++)
                this.checkRadio(ar[chi],"Value");
        }
    };
    
    this.addValue = function(vl,txt,pos)
    {
        var jsStr = '{"id":"' + vl + '","value":"' + txt + '"}';
        if(pos===undefined){
            this.json.push(JSON.parse(jsStr));
        }
        else{
            this.json.splice(pos,0,JSON.parse(jsStr));
        }
    };
    
    this.addCheckBox = function(vl,txt,pos)
    {
        var id = this.Container + "_" + this.CTLName;
        var liref = null;
        var dvchk = $("<div class='form-check form-check-inline " + id + "_DIV' style='margin-left:5px'> <input type='checkbox' class='form-check-input " + id + "_CheckBox' value='" + vl + "' name='" + id + "_name' />  <label class='form-check-label " + id + "_Label'>" + txt + "</label> </div>");
        if(pos===undefined){
            $("#"+id+"_control").append(dvchk);
        }
        else{
            if(pos<this.json.length)
            {
                liref = $("#"+this.CTLName+"_control div").eq(pos);
                if(pos===0)
                    liref.before(dvchk);
                else
                    liref.append(dvchk);
            }
            else
                $("#"+id+"_control").append(dvchk);
        }
        this.addValue(vl,txt,pos);
        
        try{
            this.ParentClassV.HC_Select_AddRadio(vl,txt,pos);
        }catch(e){} 
        
        try{
            window[id+"_AddCheckBox"](vl,txt,pos);
        }catch(e){};
        
        var parent = this;
        
        $("."+id+"_CheckBox").unbind("click");
        $("."+id+"_CheckBox").click(function(){
            var cobj = $("."+id+"_CheckBox");
            var lobj = $("."+id+"_Label");
            var idx = $(this).index();
            var chked = $(this).prop("checked");
            
            var txt = "",vl = "";
            for(i=0;i<cobj.length;i++)
            {
                var chk = cobj.eq(i);
                if(chk.prop("checked")){
                    txt += "," + chk.val();
                    vl += "," + lobj.eq(i).html();
                }
            }
            
            if(txt!==""){
            parent.setText(txt.substring(1));
            parent.setValue(vl.substring(1));
            }
            
            try{
                window[id+"_RadioChecked"](idx,chked);
            }catch(e){};
            
            try{
                if(this.ParentClassV!==null){
                    parent.ParentClassV.radioChecked(idx,chked);
                }
            }catch(e){};
            
            
         });
        
         $("."+id+"_CheckBox").unbind("focusin");
         $("."+id+"_CheckBox").focusin(function(){
              $(this).next("label").addClass("HC_CheckBox_Focus");
         });
         
         $("."+id+"_CheckBox").unbind("focusout");
         $("."+id+"_CheckBox").focusout(function(){
              $(this).next("label").removeClass("HC_CheckBox_Focus");
         });
         
         $("."+id+"_CheckBox").unbind("keyup");
         $("."+id+"_CheckBox").keyup(function(e){
              if(e.which===13)
                  parent.gotoNextControl();
         });
    };
    
    
    this.removeCheckBox = function(pos)
    {
        var id = this.Container + "_" + this.CTLName;
        if(pos<this.json.length){
            this.json.splice(pos,1);
            $("#"+id+"_CheckBoxContainer div").eq(pos).remove();
        }
        
        try{
            this.ParentClassV.HC_Select_RemoveCheckBox(pos);
        }catch(e){} 
        
        try{
            window[id+"_RemoveCheckBox"](pos);
        }catch(e){};
    };
    
    this.removeAllCheckBox = function()
    {
        var id = this.Container + "_" + this.CTLName;
        this.json = [];
        var lbl = $("#"+id+"_label").html();
        //lbl.html("mango");
        $("#"+id+"_control").html("");
        $("#"+id+"_control").append(lbl);
    };
    
    this.populateUsingJSON = function(data,Append)
    {
        var json = new HC_Json(data);
        var i,j;
        var stpt = 0;
        if(Append===true)
            var stpt = this.json.length;
            
        for(i=stpt;i<stpt+json.getArRowLength();i++){
            this.addCheckBox(json.getArVI(i-stpt,0),json.getArVI(i-stpt,1));
        }
    };
    
    this.populatefromAjax = function(AjaxID,WhereCL,Append){
        this.Ajax.AjaxID = AjaxID;
        this.Ajax.CMN_WhereCL = WhereCL;
        this.Ajax.CMN_WhereData = '';
        var parent = this;
        this.Ajax.CallServer(function(data){
            
            var jsonObj = JSON.parse(data);
            var fr = JSON.stringify(jsonObj[0]);
            fr = JSON.parse(fr);
            fr[parent.TextField] = "";
            fr[parent.ValueField] = "";
            jsonObj.splice(0,0,fr);
            
            if(Append===false || Append===undefined){
                parent.removeRowAll();
                parent.populateUsingJSON(JSON.stringify(jsonObj),false);
            }
            else{
                parent.populateUsingJSON(JSON.stringify(jsonObj),true);
            }
        });
    };
    
    this.setFocus = function(pos){
        var id = this.Container + "_" + this.CTLName;
        if(pos===undefined)
            pos = 0;
        if(pos<this.json.length){
            var chk = $("."+id+"_CheckBox").eq(pos);
            chk.focus();
        }
    };
    
    this.gotoNextControl = function()
    {
        var id = this.Container + "_" + this.CTLName;
        if(this.NextControl!==null)
        {
            try{
            this.NextControl.setFocus();
            }catch(e){}
            
            try{
                window[id+"_gotoNextControl"](id,this.NextControl);
            }catch(e){};
            
            try{
                if(this.ParentClassV!==null){
                    this.ParentClassV.gotoNextControl(id,this.NextControl);
                }
            }catch(e){};
        }
    };
    
    this.clearAll = function()
    {
        var id = this.Container + "_" + this.CTLName;
        this.setText("");
        this.setValue("");
        $("#"+id+"_container").removeClass("HC_RadioValidationTrue");
        
        var tjson = JSON.stringify(this.json);
        this.removeAllCheckBox();
        this.populateUsingJSON(tjson);
    };
    
    this.validateBlank = function(){
        var tb = this.Container + "_" + this.CTLName;
        if(this.Text.trim()==="")
        {
            $("#"+tb+"_ermsg").html("Please Enter " + this.Label);
            $("#"+tb+"_ermsg").addClass("HC_RadioErrorMSG");
            $("#"+tb+"_container").removeClass("HC_RadioValidationTrue");
            $("#"+tb+"_container").addClass("HC_RadioValidationFalse");
            return this;
        }
        else{
            $("#"+tb+"_ermsg").removeClass("HC_RadioErrorMSG");
            $("#"+tb+"_container").removeClass("HC_RadioValidationFalse");
            $("#"+tb+"_container").addClass("HC_RadioValidationTrue");
            $("#"+tb+"_ermsg").html("");
            return null;
        }
    };
    
    this.validateVTP = function(){
        return null;
    };
    
    this.setBSColumn = function(ln)
    {
        /*var id = this.CTLName;
        var bscol = "col-sm-" + ln;
        var dv = $("#"+id + "_container");
        if(this.BSColumn===""){
            this.BSColumn = bscol;
            dv.addClass(bscol);
        }
        else{
            dv.removeClass(this.BSColumn);
            this.BSColumn = bscol;
            dv.addClass(bscol);
        }*/
    };
    
    this.setTextValue = function(txt,vl)
    {
        this.setText(txt);
        this.setValue(vl);
    };
    
    this.setMaxLength = function(ln)
    {
        
    };
};

function HC_Radio(CTLName,pJSON,pParentClassV)
{
    this.CTLName = CTLName || "";
    this.json = pJSON || [];
    this.Text = "";
    this.Value = "";
    this.Label = new HC_Label(this.CTLName+"_label");
    this.SelectedIndex = -1;
    this.ParentClassV = pParentClassV || null;
    this.Ajax = new HC_Ajax();
    this.ShowLabel = true;
    this.NextControl = null;
    this.BSColumn = "";
    this.Container = "";
    this.generateControl = function(CTLContainer)
    {
         this.Container = CTLContainer;
         var id = this.Container + "_" + this.CTLName;
         var dv = $("<div id='" + id + "_RadioContainer'></div>");
         var chHidden = $("<input id='" + id + "' type='hidden' />");
         dv.append(chHidden);
         var dvctl = $("<div id='" + id + "_control' class='input-group mb-2 input-group-sm'></div>");
         dv.append(dvctl);
         
         //var lbl = $("<span id='" + this.CTLName + "_label' >" + this.Label + "</span>");
         //dvctl.append(lbl);
         this.Label.generateControlJQObject(dvctl);
         
         var errmsg = "<div id='" + id + "_ermsg'></div>";
         dv.append(errmsg);
         
         $("#" + CTLContainer).append(dv);
         
         $("#" + this.CTLName+"_label").addClass("HC_RadioCheckBox_Label");
         
         if(this.json!==null && this.json.length>0)
         {
            var tjson = JSON.stringify(this.json);
            this.json = [];
            this.populateUsingJSON(tjson);
         }
    };
    
    this.Dispose = function()
    {
        this.removeAllRadio();
        var id = this.Container + "_" + this.CTLName;
        $("#" + id + "_ermsg").remove();
        $("#" + id + "_control").remove();
        $("#" + id).remove();
        $("#" + id + "_CheckBoxContainer").remove();
    };
    
    this.setLabel = function(pLabel)
    {
        this.Label.setLabel(pLabel);
    };
    
    this.setShowLabel = function(tf)
    {
        this.Label.ShowLabel(tf);
    };
    
    this.generateControlJQObject = function(CTLContainer)
    {
         this.Select.generateControlJQObject(CTLContainer);
    };
    
    this.setText = function(txt)
    {
        var id = this.Container + "_" + this.CTLName;
        $('#'+id).val(txt);
        this.Text = txt;
        this.checkRadio(txt,"Text");
    };
    
    this.checkRadio = function(txt,vlTP)
    {
        var cobj = $("."+this.CTLName+"_Radio");
        var lobj = $("."+this.CTLName+"_Label");
        for(var ci=0;ci<cobj.length;ci++)
        {
            var chk = cobj.eq(ci);
            if(vlTP==="Text"){
                if(txt===chk.val())
                    chk.prop("checked",true);
            }
            if(vlTP==="Value"){
                if(txt===lobj.eq(ci).html())
                    chk.prop("checked",true);
            }
        }
    };
    
    this.setValue = function(txt)
    {
        this.Value = txt;
        this.checkRadio(txt,"Value");
    };
    
    this.addValue = function(vl,txt,pos)
    {
        var jsStr = '{"id":"' + vl + '","value":"' + txt + '"}';
        if(pos===undefined){
            this.json.push(JSON.parse(jsStr));
        }
        else{
            this.json.splice(pos,0,JSON.parse(jsStr));
        }
    };
    
    this.addRadio = function(vl,txt,pos)
    {
        var id = this.Container + "_" + this.CTLName;
        
        var liref = null;
        var dvchk = $("<div class='form-check form-check-inline " + id + "_DIV' style='margin-left:5px'> <input type='radio' class='form-check-input " + id + "_Radio' value='" + vl + "' name='" + id + "_name' />  <label class='form-check-label " + id + "_lbl'>" + txt + "</label> </div>");
        if(pos===undefined){
            $("#"+id+"_control").append(dvchk);
        }
        else{
            if(pos<this.json.length)
            {
                liref = $("#"+id+"_control div").eq(pos);
                if(pos===0)
                    liref.before(dvchk);
                else
                    liref.append(dvchk);
            }
            else
                $("#"+id+"_control").append(dvchk);
        }
        this.addValue(vl,txt,pos);
        
        try{
            this.ParentClassV.HC_Select_AddRadio(vl,txt,pos);
        }catch(e){} 
        
        try{
            window[id+"_AddRadio"](vl,txt,pos);
        }catch(e){};
        
        var parent = this;
        
        $("."+id+"_Radio").unbind("click");
        $("."+id+"_Radio").click(function(){
            var cobj = $("."+id+"_Radio");
            var lobj = $("."+id+"_Label");
            var txt = "",vl = "";
            for(i=0;i<cobj.length;i++)
            {
                var chk = cobj.eq(i);
                if(chk.prop("checked")){
                    txt += "," + chk.val();
                    vl += "," + lobj.eq(i).html();
                }
            }
            
            if(txt!==""){
            parent.setText(txt.substring(1));
            parent.setValue(vl.substring(1));
            }
         });
        
         $("."+id+"_Radio").unbind("focusin");
         $("."+id+"_Radio").focusin(function(){
              $(this).next("label").addClass("HC_CheckBox_Focus");
         });
         
         $("."+id+"_Radio").unbind("focusout");
         $("."+id+"_Radio").focusout(function(){
              $(this).next("label").removeClass("HC_CheckBox_Focus");
         });
         
         $("."+id+"_Radio").unbind("keyup");
         $("."+id+"_Radio").keyup(function(e){
              if(e.which===13)
              {
                  parent.gotoNextControl();
              }
         });
    };
    
    this.removeRadio = function(pos)
    {
        var id = this.Container + "_" + this.CTLName;
        if(pos<this.json.length){
            this.json.splice(pos,1);
            $("#"+ide+"_container div").eq(pos).remove();
        }
        
        try{
            this.ParentClassV.HC_Select_RemoveCheckBox(pos);
        }catch(e){} 
        
        try{
            window[id+"_RemoveRadio"](pos);
        }catch(e){};
    };
    
    this.removeAllRadio = function()
    {
        var id = this.Container + "_" + this.CTLName;
        this.json = [];
        var lbl = $("#"+this.CTLName+"_label").html();
        //lbl.html("mango");
        $("#"+id+"_control").html("");
        $("#"+id+"_control").append(lbl);
    };
    
    this.populateUsingJSON = function(data,Append)
    {
        var json = new HC_Json(data);
        var i,j;
        var stpt = 0;
        if(Append===true)
            var stpt = this.json.length;
            
        for(i=stpt;i<stpt+json.getArRowLength();i++){
            this.addRadio(json.getArVI(i-stpt,0),json.getArVI(i-stpt,1));
        }
    };
    
    this.populatefromAjax = function(AjaxID,WhereCL,Append){
        this.Ajax.AjaxID = AjaxID;
        this.Ajax.CMN_WhereCL = WhereCL;
        this.Ajax.CMN_WhereData = '';
        var parent = this;
        this.Ajax.CallServer(function(data){
            if(Append===false || Append===undefined){
                parent.removeRowAll();
                parent.populateUsingJSON(data,false);
            }
            else{
                parent.populateUsingJSON(data,true);
            }
        });
    };
    
    this.setFocus = function(pos){
        if(pos===undefined)
            pos = 0;
        if(pos<this.json.length){
            var chk = $("."+this.CTLName+"_Radio").eq(pos);
            chk.focus();
        }
    };
    
    this.gotoNextControl = function()
    {
        var id = this.Container + "_" + this.CTLName;
        if(this.NextControl!==null)
        {
            try{
            this.NextControl.setFocus();
            }catch(e){}
            
            try{
                window[id+"_gotoNextControl"](id,this.NextControl);
            }catch(e){};
            
            try{
                if(this.ParentClassV!==null){
                    this.ParentClassV.gotoNextControl(id,this.NextControl);
                }
            }catch(e){};
        }
    };
    
    this.clearAll = function()
    {
        var id = this.Container + "_" + this.CTLName;
        this.setText("");
        this.setValue("");
        $("#"+id+"_container").removeClass("HC_RadioValidationTrue");
        
        var tjson = JSON.stringify(this.json);
        this.removeAllRadio();
        this.populateUsingJSON(tjson);
    };
    
    this.validateBlank = function(){
        var tb = this.Container + "_" + this.CTLName;
        if(this.Text.trim()==="")
        {
            $("#"+tb+"_ermsg").html("Please Enter " + this.Label);
            $("#"+tb+"_ermsg").addClass("HC_RadioErrorMSG");
            $("#"+tb+"_container").removeClass("HC_RadioValidationTrue");
            $("#"+tb+"_container").addClass("HC_RadioValidationFalse");
            return this;
        }
        else{
            $("#"+tb+"_ermsg").removeClass("HC_RadioErrorMSG");
            $("#"+tb+"_container").removeClass("HC_RadioValidationFalse");
            $("#"+tb+"_container").addClass("HC_RadioValidationTrue");
            $("#"+tb+"_ermsg").html("");
            return null;
        }
    };
    
    this.validateVTP = function(){
        return null;
    };
    
    this.setBSColumn = function(ln)
    {
        /*var id = this.CTLName;
        var bscol = "col-sm-" + ln;
        var dv = $("#"+id + "_container");
        if(this.BSColumn===""){
            this.BSColumn = bscol;
            dv.addClass(bscol);
        }
        else{
            dv.removeClass(this.BSColumn);
            this.BSColumn = bscol;
            dv.addClass(bscol);
        }*/
    };
    
    this.setTextValue = function(txt,vl)
    {
        this.setText(txt);
        this.setValue(vl);
    };
    
    this.setReadOnly = function(pReadOnly){
        var i;
        for(i=0;i<this.json.length;i++){
            $("."+this.CTLName+"_Radio").eq(i).prop("disabled",pReadOnly);
        }
    };
};



function HC_Button(CTLName,pLabel,pParentClassV)
{
    this.CTLName = CTLName || "";
    this.Label = pLabel || "";
    this.BSEnable = true;
    this.Enable = true;
    this.ButtonType = "btn-secondary";
    this.Event = null;
    this.ParentClassV = pParentClassV || null;
    this.Container = "";
    this.Visisble = true;
    
    this.GenrateCTL = function(CTLContainer,ObjTF)
    {
         if(!ObjTF)
            this.Container = CTLContainer;
         else
             this.Container = "";
         
         var id = this.getID();
         
         var button = "<button type='button' style='margin:2px' class='btn btn-sm " + this.ButtonType + "' id='" + id  + "'>" + this.Label + "</button>";
         
         if(ObjTF===false)
            $("#" + CTLContainer).append(button);
         else
             CTLContainer.append(button);
         
         this.setupEvent();
    };
    
    
    this.Dispose = function()
    {
         var id = this.getID();
         $("#"+id).unbind("click");
         $("#"+id).remove();
    };
    
    this.setupEvent = function()
    {
        var id = this.getID();
        var parent = this;
        $("#"+id).unbind("click");
        $("#"+id).click(function(){
            
        try{
           if(parent.ParentClassV!==null)
            parent.ParentClassV.buttonClicked(id);

           window[id+"_buttonClicked"](id);
        }catch(e){};

        if(parent.Event!==null)
           parent.Event();
        });
    };
    
    this.setButtonType = function(btp)
    {
        var id = this.getID();
        $("#"+id).removeClass(this.ButtonType);
        this.ButtonType = btp;
        $("#"+id).addClass(this.ButtonType);
    };
    
    this.generateControl = function(CTLContainer)
    {
         this.GenrateCTL(CTLContainer,false);
    };
    
    this.generateControlJQObject = function(CTLContainer)
    {
        this.GenrateCTL(CTLContainer,true);
    };
    
    this.setBS = function(tf)
    {
        var id = this.getID();
        if(tf)
        {
            $("#"+id).addClass(this.ButtonType);
        }
        else
        {
            $("#"+id).removeClass(this.ButtonType);
        }
        this.BSEnable = tf;
    };
    
    this.setLabel = function(pLabel)
    {
        var id = this.getID();
        this.Label = pLabel;
        $("#"+id).html(pLabel);
    };
    
    this.getLabel = function()
    {
        return this.Label;
    };
    
    this.setEvent = function(event)
    {
        this.Event = event;
        this.setupEvent();
    };
    
    this.setEnable = function(tf)
    {
        var id = this.getID();
        if(tf)
        {
            $("#"+id).prop("disabled",false);
        }
        else
        {
            $("#"+id).prop("disabled",true);
        }
        this.Enable = tf;
    };
    
    this.setVisible = function(tf)
    {
        var id = this.getID();
        if(tf)
        {
            $("#"+id).show();
        }
        else
        {
            $("#"+id).hide();
        }
        this.Visisble = tf;
    };
    
    this.setMaxLength = function(ln)
    {
        
    };
    
    this.getID = function()
    {
        if(this.Container!=="")
            return this.Container + "_" + this.CTLName;
        else
            return this.CTLName;
    };
    
    this.setFocus = function(){
        $("#"+this.getID()).focus();
    };
    
};

function HC_ButtonGroup(pButtonGroup,pParentClassV)
{
    this.ButtonGroup = pButtonGroup || "";
    this.Buttons = []; 
    this.ButtonNames = [];
    this.Container = "";
    this.ParentClassV = pParentClassV || null;
        
    this.buttonClicked = function(btnnm)
    {
        var id = this.getID();
        var idx = this.getButtonIndex(btnnm);
        
        try{
            if(this.ParentClassV!==null)
                this.ParentClassV.groupButtonClicked(idx,btnnm);

           window[id+"_groupButtonClicked"](idx,btnnm);
        }catch(e){};
    };
    
    this.CreateJObject = function(pContainer,BTNName)
    {
         this.Container = "";
         this.ButtonGroup = BTNName || this.ButtonGroup;
         var id = this.getID();
         var bg = $("<div class='text-right' id='" + id + "_Group'><div class='btn-group' id='" + id + "'></div></div>");
         pContainer.append(bg);
    };
    
    this.Create = function(pContainer)
    {
         this.Container = pContainer;
         var id = this.getID();
         var bg = $("<div class='text-right' id='" + id + "_Group'><div class='btn-group' id='" + id + "'></div></div>");
         $("#"+this.Container).append(bg);
    };
    
    this.Dispose = function()
    {
        var id = this.getID();
        this.removeAllButton();
        this.Buttons = [];
        this.ButtonNames = [];
        $("#"+ id + "_Group").remove();
    };
    
    this.setButtonLeft = function()
    {
         var id = this.getID();
         $("#"+id+"_Group").removeClass("text-right");
         $("#"+id+"_Group").removeClass("text-left");
         $("#"+id+"_Group").addClass("text-left");
    };
    
    this.setButtonRight = function()
    {
         var id = this.getID();
         $("#"+id+"_Group").removeClass("text-right");
         $("#"+id+"_Group").removeClass("text-left");
         $("#"+id+"_Group").addClass("text-right");
    };
    
    this.addButton = function(pButtonName,pLabel,event)
    {
        this.ButtonNames.push(pButtonName);
        var btn = new HC_Button(pButtonName,pLabel,this);
        btn.generateControlJQObject($("#" + this.getID()));
        if(event!==undefined)
            btn.setEvent(event);
            
        this.Buttons.push(btn);
    };
    
    this.removeButton_Name = function(TabName)
    {
        var idx = this.ButtonNames.indexOf(TabName);
        this.Buttons[idx].removeControl();
    };
    
    this.removeAllButton = function()
    {
        var i;
        for(i=0;i<this.Buttons.length;i++)
            this.Buttons[i].Dispose();
    };
    
    this.removeButton = function(idx)
    {
        this.Buttons[idx].Dispose();
    };
    
    this.setLabel = function(idx,label)
    {
        this.Buttons[idx].setLabel(label);
    };
      
    this.getLabel = function(idx)
    {
        return this.Buttons[idx].getLabel();
    };
    
    this.isButtonExists = function(ButtonName)
    {
        //TabName = this.Container + "_" + TabName;
        if(this.ButtonNames.indexOf(ButtonName)>=0)
            return true;
        else
            return false;
    };
    
    this.getButtonFromKey = function(key)
    {
        return this.Buttons[this.ButtonNames.indexOf(key)];
    };
    
    this.getButtonIndex = function(ButtonName)
    {
        return this.ButtonNames.indexOf(ButtonName);
    };
    
    this.setButtonType = function(idx,btp)
    {
        this.Buttons[idx].setButtonType(btp);
    };
    
    this.setButtonTypeAll = function(btp)
    {
        for(i=0;i<this.Buttons.length;i++)
            this.Buttons[i].setButtonType(btp);
    };
    
    this.setEnable = function(idx,tf)
    {
        this.Buttons[idx].setEnable(tf);
    };
    
    this.getButtonsCount = function()
    {
        return this.Buttons.length;
    };
    
    this.setEnableAll = function()
    {
        for(i=0;i<this.Buttons.length;i++)
            this.Buttons[i].setEnable(true);
    };
    
    this.setDisableAll = function()
    {
        for(i=0;i<this.Buttons.length;i++)
            this.Buttons[i].setEnable(false);
    };
    
    this.setVisibleAll = function(idx,tf)
    {
        this.Buttons[idx].setVisible(tf);
    };
    
    this.setShowAll = function()
    {
        for(i=0;i<this.Buttons.length;i++)
            this.Buttons[i].setVisible(true);
    };
    
    this.setHideAll = function()
    {
        for(i=0;i<this.Buttons.length;i++)
            this.Buttons[i].setVisible(false);
    };
    
    this.setEvent = function(idx,event)
    {
        this.Buttons[idx].setEvent(event);
    };
    
    this.setBS = function(idx,tf)
    {
        this.Buttons[idx].setBS(tf);
    };
    
    this.setVisible = function(tf)
    {
        var id = this.getID();
        if(tf)
            $("#"+id + "_Group").show();
        else
            $("#"+id + "_Group").hide();
    };

    this.getID = function()
    {
        if(this.Container!=="")
            return this.Container + "_" + this.ButtonGroup;
        else
            return this.ButtonGroup;
    };
    
};

function HC_Menu(CTLName,pLabel,pLink,pParentClassV)
{
    this.CTLName = CTLName || "";
    this.Label = pLabel || "";
    this.Link = pLink || "#";
    this.BSEnable = true;
    this.Enable = true;
    this.Event = null;
    this.ParentClassV = pParentClassV || null;
    this.Container = "";
    this.GenrateCTL = function(CTLContainer,ObjTF)
    {
         if(!ObjTF)
            this.Container = CTLContainer;
         else
             this.Container = "";
         
         var id = this.getID();
         
         var button = "<a href='" + this.Link + "' class='list-group-item list-group-item-action bg-light' id='" + id  + "'>" + this.Label + "</a>";
         
         if(ObjTF===false)
            $("#" + CTLContainer).append(button);
         else
             CTLContainer.append(button);
         
         this.setupEvent();
    };
    
    
    this.Dispose = function()
    {
         var id = this.getID();
         $("#"+id).unbind("click");
         $("#"+id).remove();
    };
    
    this.setupEvent = function()
    {
        var id = this.getID();
        var parent = this;
        $("#"+id).unbind("click");
        
        $("#"+id).click(function(){
            try{
               if(parent.ParentClassV!==null)
                parent.ParentClassV.menuClicked(id);

               window[id+"_menuClicked"](id);
            }catch(e){};

            if(parent.Event!==null)
               parent.Event();
            });
    };
    
    this.generateControl = function(CTLContainer)
    {
         this.GenrateCTL(CTLContainer,false);
    };
    
    this.generateControlJQObject = function(CTLContainer)
    {
        this.GenrateCTL(CTLContainer,true);
    };
    
    this.setLabel = function(pLabel)
    {
        var id = this.getID();
        this.Label = pLabel;
        $("#"+id).html(pLabel);
    };
    
    this.setLink = function(pLink)
    {
        var id = this.getID();
        this.Link = pLink;
        $("#"+id).prop("href",pLink);
    };
    
    this.setEvent = function(event)
    {
        this.Event = event;
        this.setupEvent();
    };
    
    this.setEnable = function(tf)
    {
        var id = this.getID();
        if(tf)
        {
            $("#"+id).prop("disabled",false);
        }
        else
        {
            $("#"+id).prop("disabled",true);
        }
        this.Enable = tf;
    };
    
    this.Dispose = function()
    {
        var id = this.getID();
        $("#"+id).remove();
    };
    
    this.setMaxLength = function(ln)
    {
        
    };
    
    this.getID = function()
    {
        if(this.Container!=="")
            return this.Container + "_" + this.CTLName;
        else
            return this.CTLName;
    };
};

function HC_MenuGroup(pMenuGroup,pLabel,pParentClassV)
{
    this.MenuGroup = pMenuGroup || "";
    this.Menus = [];
    this.Label = pLabel || "";
    this.MenuNames = [];
    this.Container = "";
    this.ParentClassV = pParentClassV || null;
    this.Modal = new HC_BSModal(pMenuGroup+"_Model",this);
    this.buttonClicked = function(btnnm)
    {
        var id = this.getID();
        var idx = this.getButtonIndex(btnnm);
        
        try{
            if(this.ParentClassV!==null)
                this.ParentClassV.groupButtonClicked(idx,btnnm);

           window[id+"_groupButtonClicked"](idx,btnnm);
        }catch(e){};
    };
    
    this.CreateJObject = function(pContainer)
    {
         this.Container = "";
         var id = this.getID();
         var mg = "<a href='#" + this.MenuGroup + "' id='" + id + "_Link' data-toggle='collapse' aria-expanded='false' class='dropdown-toggle list-group-item list-group-item-action bg-light'>" + id + "</a>";
         mg += "<div class='collapse list-unstyled' id='" + id  + "'></div>";
         var bg = $(mg);
         pContainer.append(bg);
    };
    
    this.Create = function(pContainer)
    {
         this.Container = pContainer;
         var id = this.getID();
         var mg = "<a href='#" + this.MenuGroup + "' id='" + id + "_Link' data-toggle='collapse' aria-expanded='false' class='dropdown-toggle list-group-item list-group-item-action bg-light'>" + id + "</a>";
         mg += "<div class='collapse list-unstyled' id='" + id  + "'></div>";
         var bg = $(mg);
         $("#"+this.Container).append(bg);
    };
    
    this.setMenuGroupLabel = function(pLabel)
    {
        var id = this.getID();
        $("#"+ id + "_Link").html(pLabel);
    };
    
    this.Dispose = function()
    {
        var id = this.getID();
        this.Modal.Dispose();
        this.removeAllMenu();
        this.Menus = [];
        this.MenuNames = [];
        $("#"+ id).remove();
        $("#"+ id + "_Link").remove();
    };
    
    this.addMenu = function(pMenuName,pLabel)
    {
        this.MenuNames.push(pMenuName);
        var btn = new HC_Menu(pMenuName,pLabel,"#",this);
        btn.generateControlJQObject($("#" + this.getID()));
        this.Menus.push(btn);
    };
    
    this.removeButton_Name = function(TabName)
    {
        var idx = this.MenuNames.indexOf(TabName);
        this.Menus[idx].removeControl();
    };
    
    this.removeAllMenu = function()
    {
        var i;
        for(i=0;i<this.Menus.length;i++)
            this.Menus[i].Dispose();
    };
    
    this.removeButton = function(idx)
    {
        this.Menus[idx].Dispose();
    };
    
    this.setLabel = function(idx,label)
    {
        this.Menus[idx].setLabel(label);
    };
        
    this.isButtonExists = function(ButtonName)
    {
        //TabName = this.Container + "_" + TabName;
        if(this.MenuNames.indexOf(ButtonName)>=0)
            return true;
        else
            return false;
    };
    
    this.getButtonIndex = function(ButtonName)
    {
        return this.MenuNames.indexOf(ButtonName);
    };
    
    this.setEnable = function(idx,tf)
    {
        this.Menus[idx].setEnable(tf);
    };
    
    this.setEnableAll = function()
    {
        for(i=0;i<this.Menus.length;i++)
            this.Menus[i].setEnable(true);
    };
    
    this.setDisableAll = function()
    {
        for(i=0;i<this.Menus.length;i++)
            this.Menus[i].setEnable(false);
    };
    
    this.setEvent = function(idx,event)
    {
        this.Menus[idx].setEvent(event);
    };
    
    this.setLink = function(idx,link)
    {
        this.Menus[idx].setLink(link);
    };
    
    this.setVisible = function(tf)
    {
        var id = this.getID();
        if(tf)
            $("#"+id + "_Link").show();
        else
            $("#"+id + "_Link").hide();
    };
    
    this.Toggle = function()
    {
        var id = this.getID();
        $("#"+id + "_Link").click();
        
    };
    
    this.getID = function()
    {
        if(this.Container!=="")
            return this.Container + "_" + this.MenuGroup;
        else
            return this.MenuGroup;
    };
    
    this.OpenMenuModal = function(pContainer)
    {
        this.Modal.CreateJQObject(pContainer);
        this.CreateJObject($("#"+this.Modal.ModalName+"_body"));
        this.Modal.OpenModal();
    };
    
    this.CloseMenuModal = function()
    {
        this.Modal.CloseModal();
    };
    
    this.ModalClose = function()
    {
        this.Modal.CloseModal();
        this.Dispose();
    };
    
};


function HC_Calender(CTLName,pParentClassV)
{
    this.CTLName = CTLName || "";
    this.GridView = new HC_GridView(this.CTLName + "_Grid",this);
    this.Text = "";
    this.Value = "";
    this.Date = new HC_Date();
    this.showYear = true;
    this.showMonth = true;
    this.ParentClassV = pParentClassV || null;
    this.Container = "";
    this.tempTXT = "";
    
    this.showCalender = function(){
        var id = this.getID();
        $("#" + id).show();
    };
    
    this.hideCalender = function(){
        var id = this.getID();
        $("#" + id).hide();
    };
    
    this.getID = function()
    {
        if(this.Container!=="")
            return this.Container + "_" + this.CTLName;
        else
            return this.CTLName;
    };
    
    this.setText = function(txt)
    {
        this.Text = txt;
    };
    
    this.setValue = function(txt)
    {
        this.Value = txt;
    };
    
    this.clearAll = function()
    {
        this.setText("");
        this.setValue("");
    };
    
    this.Dispose = function()
    {
        var id = this.getID();
        
        $("#" + id).remove();
        
        $("#" + id + "_Date").remove();
        $("#" + id + "_DateDIV").remove();
        $("#" + id + "_prevYear").remove();
        $("#" + id + "_Year").remove();
        $("#" + id + "_nextYear").remove();
        $("#" + id + "_YearDIV").remove();
        $("#" + id + "_prevMonth").remove();
        $("#" + id + "_Year").remove();
        $("#" + id + "_nextMonth").remove();
        $("#" + id + "_MonthDIV").remove();
    };
    
    this.generateControl = function(CTLContainer)
    {
         this.Container = CTLContainer || "";
         
         var id = this.getID();
         
         $("#" + CTLContainer).append("<div id=" + id + " style='background-color:whitesmoke;width:210px'></div>");
         
         this.GenerateAdditional();
        
    };
    
    
    this.generateControlJQObject = function(CTLContainer)
    {
          var id = this.getID();
         
         CTLContainer.append("<div id=" + id + " style='background-color:whitesmoke;width:210px'></div>");
         
         this.GenerateAdditional();
         
    };
    
    this.GenerateAdditional = function(){
        
        var id = this.getID();
        var dvdt = $("#" + id);
        var parent = this;
       
        var btndt = $("<button id='" + id + "_Date' type='button' style='padding:1px;width:210px' disabled class='btn btn-outline-primary btn-sm'></button>");
        dvdt.append(btndt);
        
        var dvyr = $("<div id='" + id + "_YearDIV'></div>");
        var btnyrprev = $("<button id='" + id + "_prevYear' type='button' style='padding:1px;width:30px' class='btn btn-outline-primary btn-sm'> << </button>");
        var btnyr = $("<button id='" + id + "_Year' type='button' style='padding:1px;width:150px' disabled class='btn btn-outline-primary btn-sm'>2020</button>");
        var btnyrnext = $("<button id='" + id + "_nextYear' type='button' style='padding:1px;width:30px' class='btn btn-outline-primary btn-sm'> >> </button>");
        dvyr.append(btnyrprev);
        dvyr.append(btnyr);
        dvyr.append(btnyrnext);
        dvdt.append(dvyr);
        
        var dvmn = $("<div id='" + id + "_MonthDIV'></div>");
        var btnmnprev = $("<button id='" + id + "_prevMonth' type='button' style='padding:1px;width:30px' class='btn btn-outline-primary btn-sm'> << </button>");
        var btnmn = $("<button id='" + id + "_Month' type='button' style='padding:1px;width:150px' disabled class='btn btn-outline-primary btn-sm'>January</button>");
        var btnmnnext = $("<button id='" + id + "_nextMonth' type='button' style='padding:1px;width:30px' class='btn btn-outline-primary btn-sm'> >> </button>");

        dvmn.append(btnmnprev);
        dvmn.append(btnmn);
        dvmn.append(btnmnnext);

        dvdt.append(dvmn);
        
        
        this.GridView.CreateGridObject($("#"+id));
        this.GridView.setDefaultWidth(false);
        this.GridView.showFooter(false);
        this.GridView.setGridViewHeight(100);
           
        for(i=0;i<7;i++){
            this.GridView.AddColumn(this.Date.charWeekday(i).substring(0,2),this.Date.charWeekday(i).substring(0,2),30);
        }
            
        for(i=1;i<=6;i++)
        {
            this.GridView.addRow();
        }
        
        this.GridView.defineEvents();
        
        this.GridView.showRowHeader(false);
        
        this.LoadMonthData();
            
        for(var i=0;i<this.GridView.getColumnLength();i++){
            this.GridView.setColumnAlignment(i,"C");
        }
            
        $("#" + id + "_nextMonth").unbind("click");
        $("#" + id + "_nextMonth").click(function(){
             parent.nextMonth();
             try{
                parent.ParentClassV.ChangeDateClick("NextMonth");
             }catch(e){};
        });

        $("#" + id + "_prevMonth").unbind("click");
        $("#" + id + "_prevMonth").click(function(){
             parent.prevMonth();
             try{
                parent.ParentClassV.ChangeDateClick("PrevMonth");
             }catch(e){};
        });

        $("#" + id + "_nextYear").unbind("click");
        $("#" + id + "_nextYear").click(function(){
             parent.nextYear();
             try{
                parent.ParentClassV.ChangeDateClick("NextYear");
             }catch(e){};
        });

        $("#" + id + "_prevYear").unbind("click");
        $("#" + id + "_prevYear").click(function(){
             parent.prevYear();
             try{
                parent.ParentClassV.ChangeDateClick("PrevYear");
             }catch(e){};
        });
        
    };
    
    this.ProcessYearDay = function(x)
    {
        if(x.length===10)
        {
            if(this.Date.ValidateUIDate(x)){
                var ar = x.split('.');
                var dy = eval(ar[0]);
                var mn = eval(ar[1]);
                var yr = eval(ar[2]);
                this.Date.year = yr;
                this.Date.month = mn;
                this.Date.day = dy;
                this.LoadMonthData();
            }
            else{
                alert("Invalid Date Format (dd.mm.yyyy)");
            }
        }
    };
    
    this.nextDay = function()
    {
        var id = this.getID();
        
        var cdt = this.Date.getUIDate();
        var ndt = this.Date.nextDay();
        
        try{
            window[id+"_NextDay"](cdt,ndt);
        }catch(e){};
            
        try{
            this.ParentClassV.Calender_NextDay(cdt,ndt);
        }catch(e){};
        
        this.LoadMonthData();
    };
    
    this.prevDay = function()
    {
        var id = this.getID();
        var cdt = this.Date.getUIDate();
        var ndt = this.Date.prevDay();
        
         try{
            window[id+"_PrevDay"](cdt,ndt);
        }catch(e){};
            
        try{
            this.ParentClassV.Calender_PrevDay(cdt,ndt);
        }catch(e){};
        
        this.LoadMonthData();
    };
    
    this.nextWeek = function()
    {
        var id = this.getID();
        var cdt = this.Date.getUIDate();
        var ndt = this.Date.nextWeek();
        
         try{
            window[id+"_NextWeek"](cdt,ndt);
        }catch(e){};
            
        try{
            this.ParentClassV.Calender_NextWeek(cdt,ndt);
        }catch(e){};
        
        this.LoadMonthData();
    };
    
    this.prevWeek = function()
    {
        var id = this.getID();
        var cdt = this.Date.getUIDate();
        var ndt = this.Date.prevWeek();
        
         try{
            window[id+"_PrevWeek"](cdt,ndt);
        }catch(e){};
            
        try{
            this.ParentClassV.Calender_PrevWeek(cdt,ndt);
        }catch(e){};
        
        this.LoadMonthData();
    };
    
    this.nextMonth = function()
    {
        var id = this.getID();
        var cdt = this.Date.getUIDate();
        var ndt = this.Date.nextMonth();
        
         try{
            window[id+"_NextMonth"](cdt,ndt);
        }catch(e){};
            
        try{
            this.ParentClassV.Calender_NextMonth(cdt,ndt);
        }catch(e){};
        
        this.LoadMonthData();
    };
    
    this.prevMonth = function()
    {
        var id = this.getID();
        var cdt = this.Date.getUIDate();
        var ndt = this.Date.prevMonth();
        
         try{
            window[id+"_PrevMonth"](cdt,ndt);
        }catch(e){};
            
        try{
            this.ParentClassV.Calender_PrevMonth(cdt,ndt);
        }catch(e){};
        
        this.LoadMonthData();
    };
    
    this.nextYear = function()
    {
        var id = this.getID();
        var cdt = this.Date.getUIDate();
        var ndt = this.Date.nextYear();
        
         try{
            window[id+"_NextYear"](cdt,ndt);
        }catch(e){};
            
        try{
            this.ParentClassV.Calender_NextYear(cdt,ndt);
        }catch(e){};
        
        this.LoadMonthData();
    };
    
    this.prevYear = function()
    {
        var id = this.getID();
        var cdt = this.Date.getUIDate();
        var ndt = this.Date.prevYear();
        
         try{
            window[id+"_PrevYear"](cdt,ndt);
        }catch(e){};
            
        try{
            this.ParentClassV.Calender_PrevYear(cdt,ndt);
        }catch(e){};
        
        this.LoadMonthData();
    };
    
    this.DateSelected = function()
    {
        var id = this.getID();
        this.Value = this.Date.getUIDate();
        this.Text = this.Date.getUIDate();
                    
        try{
            window[id+"_Calender_DateSelected"](this.Text);
        }catch(e){}
        
        try{
            this.ParentClassV.HC_Calender_DateSelected(this.Text,this.Date);
        }catch(e){} 

    };
  
     this.MatrixClick = function(json,r,c,text,value)
     {
        if(text!=="")
        {

            this.Date.setDate(value);
            this.setValue(text);
            this.setText(value);

            this.DateSelected();
            this.LoadMonthData();
        }
        else{
            this.setValue("");
            this.setText("");
        }
    };
    
    this.LoadMonthData = function()
    {
        var id = this.getID();
        
        this.GridView.clearGridView();
        var fdw = this.Date.FirstWeekIndexofMonth();
        var ldm = this.Date.LastDayofMonth();
        var t = fdw;
        var cnt = 1;
        
        var trr = Math.ceil((t + ldm) / 7);
        
        if(trr===5)
            $("#"+id+"_Search tbody tr").eq(5).hide();
        else
            $("#"+id+"_Search tbody tr").eq(5).show();
        
        for(i=0;i<6;i++)
        {
            for(j=t;j<7;j++)
            {
                 if(cnt<=ldm){
                     
                     if(cnt.toString().length===1)
                         dy = "0" + cnt;
                     else
                         dy = cnt;
                     
                     if(this.Date.month.toString().length===1)
                         mn = "0" + this.Date.month;
                     else
                         mn = this.Date.month.toString();
                     
                     this.GridView.setHTML(i,j,cnt);
                     this.GridView.setValue(i,j,dy+"."+mn+"."+this.Date.year);
                     if(cnt===this.Date.day){
                         rwi = i;
                         cli = j;
                     }
                     cnt++;
                 }
            }
            t = 0;
        }
        
        if($("#" + id + "_Month").length>0)
            $("#" + id + "_Month").html(this.Date.charMonth());
        
        if($("#" + id + "_Year").length>0)
            $("#" + id + "_Year").html(this.Date.year);
        
        if($("#" + id + "_Date").length>0)
            $("#" + id + "_Date").html(this.Date.getUIDate());
        
        //this.DatePicker.SelectDataSingle(rwi,cli);
        
        $("#"+this.CTLName+"_Grid").find("tbody tr td.TDBody").removeClass("HCG_DatePicker");
        $("#"+this.CTLName+"_Grid").find("tbody tr").eq(rwi).find("td.TDBody").eq(cli).addClass("HCG_DatePicker");
    };
    
    this.setShowYear = function(tf){
        var id = this.getID();
        this.showYear = tf;
        if(tf)
            $("#"+id+"_YearDIV").show();
        else
            $("#"+id+"_YearDIV").hide();
    };
    
    this.setShowMonth = function(tf){
        var id = this.getID();
        this.showMonth = tf;
        if(tf)
            $("#"+id+"_MonthDIV").show();
        else
            $("#"+id+"_MonthDIV").hide();
    };
    
};