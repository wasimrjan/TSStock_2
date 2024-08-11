/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

function HC_String_Query(CTLName,pParentClassV)
{
    this.CTLName = CTLName || "";
    this.Text = "";
    this.Value = "";
    this.ParentClassV = pParentClassV || null;
    this.NextControl = null;
    this.Label = new HC_Label(CTLName+"_Qlabel");
    this.TextBox = new HC_TextBox(CTLName+"_text",this);
    this.Select = new HC_Select(CTLName+"_select",[],this);
    this.Hidden = new HC_Hidden(CTLName);
    this.BSEnable = false;
    this.BSColumn = "";
    this.ReadOnly = false;
    
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
         
         var dv = "<div id='" + id + "_container' class='input-group mb-2 input-group-sm' style='height:30px;'></div>";
         
         if(ObjTF===false)
            $("#" + CTLContainer).append(dv);
         else
            CTLContainer.append(dv);
         
         var dv = $("#"+id+"_container");
                  
         this.Label.generateControlJQObject(dv);
         this.Select.generateControlJQObject(dv);
         this.Select.Select.setShowLabel(false);
         var sl = $("#"+this.CTLName+"_select");
         sl.prop("id",id+"_select");
         $("#"+this.CTLName+"_select_container").remove();
         dv.append(sl);
         this.Select.Select.setupEvents();
         
         this.Select.addRow("","");
         this.Select.addRow("Starts With","Starts With");
         this.Select.addRow("Ends With","Ends With");
         this.Select.addRow("Contains","Contains");
         this.TextBox.generateControlJQObject(dv);
         this.TextBox.TextBox.Label.setShowLabel(false);
         var tb = $("#"+this.CTLName+"_text");
         tb.prop("id",id+"_text");
         $("#"+this.CTLName+"_text_container").remove();
         dv.append(tb);
         this.TextBox.TextBox.setupEvents();
         
         $("#"+this.CTLName+"_select").addClass("col-sm-3");
         $("#"+this.CTLName+"_text").addClass("col-sm-9");
         
         if(this.ReadOnly){
             $("#"+this.CTLName+"_select").prop("disabled",true);
             $("#"+this.CTLName+"_text").prop("readonly",true);
         }
         this.Hidden.generateControlJQObject(dv);
         this.setBS(true);
         
    };
    
    this.setBS = function(tf)
    {
        this.Label.setBS(tf);
        this.TextBox.TextBox.setBS(tf);
        this.BSEnable = tf;
    };
    
    this.generateControl = function(CTLContainer,pCTLName)
    {
         this.GenrateCTL(CTLContainer,false);
    };
    
    this.generateControlJQObject = function(CTLContainer,pCTLName)
    {
         this.GenrateCTL(CTLContainer,true);
    };
    
    this.HC_Select_DataSelected = function(txt,vl,idx)
    {
        this.Text = this.Select.Text + ":" + this.TextBox.Text;
        this.Value = this.Select.Text + ":" + this.TextBox.Text;
    };
    
    this.HC_TextBox_KeyUp = function(e,txt)
    {
        this.Text = this.Select.Text + ":" + this.TextBox.Text;
        this.Value = this.Select.Text + ":" + this.TextBox.Text;
    };
    
    this.getText = function()
    {
        return this.Select.Text + ":" + this.TextBox.Text;
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
    
    this.setDropDownText = function(txt)
    {
         $("#"+this.CTLName+"_select").val(txt);
    };
    
    this.clearAll = function()
    {
        this.setText("");
        this.setValue("");
        $('#'+this.CTLName).removeClass("is-valid");
        this.TextBox.setText("");
        this.TextBox.setValue("");
        this.Select.setText("");
        this.Select.setValue("");
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
            }catch(e){};
            
            try{
                window[id+"_gotoNextControl"](this.CTLName,this.NextControl);
            }catch(e){};
            
            try{
                if(this.ParentClassV!==null){
                    this.ParentClassV.gotoNextControl(this.CTLName,this.NextControl);
                }
            }catch(e){alert(e);};
        }
    };
    
    this.RemoveControl = function()
    {
        $("#"+this.getID()+ "_container").remove();
    };
    
    this.setLabel = function(pLabel)
    {
        this.Label.setLabel(pLabel);
    };
    
    this.setShowLabel = function(tf)
    {
        this.TextBox.setShowLabel(tf);
    };
    
    this.setPlaceHolder = function(pPlaceHolder)
    {
        this.TextBox.setPlaceHolder(pPlaceHolder);
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
};

function HC_Number_Query(CTLName,pParentClassV)
{
    this.CTLName = CTLName || "";
    this.Text = "";
    this.Value = "";
    this.ParentClassV = pParentClassV || null;
    this.NextControl = null;
    this.Label = new HC_Label(CTLName+"_Qlabel");
    this.TextBoxST = new HC_TextBox(CTLName+"_textst",this);
    this.SelectST = new HC_Select(CTLName+"_selectst",[],this);
    this.TextBoxEN = new HC_TextBox(CTLName+"_texten",this);
    this.SelectEN = new HC_Select(CTLName+"_selecten",[],this);
    this.Hidden = new HC_Hidden(CTLName);
    this.BSEnable = false;
    this.BSColumn = "";
    
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
         
         var dv = "<div id='" + id + "_container' class='input-group mb-2 input-group-sm' style='height:30px;'></div>";
         
         if(ObjTF===false)
            $("#" + CTLContainer).append(dv);
         else
             CTLContainer.append(dv);
         
         var dv = $("#"+id+"_container");
                  
         this.Label.generateControlJQObject(dv);
         
         this.SelectST.generateControlJQObject(dv);
         this.SelectST.Select.setShowLabel(false);
         var sl = $("#"+this.CTLName+"_selectst");
         sl.prop("id",id+"_selectst");
         $("#"+this.CTLName+"_selectst_container").remove();
         dv.append(sl);
         this.SelectST.Select.setupEvents();
         
         this.SelectST.addRow("","");
         this.SelectST.addRow("=","=");
         this.SelectST.addRow("<","<");
         this.SelectST.addRow(">",">");
         this.SelectST.addRow("<=","<=");
         this.SelectST.addRow(">=",">=");
         
         this.TextBoxST.generateControlJQObject(dv);
         this.TextBoxST.TextBox.Label.setShowLabel(false);
         var tb = $("#"+this.CTLName+"_textst");
         tb.prop("id",id+"_textst");
         $("#"+this.CTLName+"_textst_container").remove();
         dv.append(tb);
         this.TextBoxST.TextBox.setupEvents();
         
         $("#"+this.CTLName+"_selectst").addClass("col-sm-2");
         $("#"+this.CTLName+"_textst").addClass("col-sm-4");

          //end section
        
         this.SelectEN.generateControlJQObject(dv);
         this.SelectEN.Select.setShowLabel(false);
         var sl = $("#"+this.CTLName+"_selecten");
         sl.prop("id",id+"_selecten");
         $("#"+this.CTLName+"_selecten_container").remove();
         dv.append(sl);
         this.SelectEN.Select.setupEvents();
         
         this.SelectEN.addRow("","");
         this.SelectEN.addRow("=","=");
         this.SelectEN.addRow("<","<");
         this.SelectEN.addRow(">",">");
         this.SelectEN.addRow("<=","<=");
         this.SelectEN.addRow(">=",">=");
         
         this.TextBoxEN.generateControlJQObject(dv);
         this.TextBoxEN.TextBox.Label.setShowLabel(false);
         var tb = $("#"+this.CTLName+"_texten");
         tb.prop("id",id+"_texten");
         $("#"+this.CTLName+"_texten_container").remove();
         dv.append(tb);
         this.TextBoxEN.TextBox.setupEvents();
         
         $("#"+this.CTLName+"_selecten").addClass("col-sm-2");
         $("#"+this.CTLName+"_texten").addClass("col-sm-4");
         
         
         this.Hidden.generateControlJQObject(dv);
         this.setBS(true);
         
    };
    
    this.setBS = function(tf)
    {
        this.Label.setBS(tf);
        this.TextBoxST.TextBox.setBS(tf);
        this.TextBoxEN.TextBox.setBS(tf);
        this.BSEnable = tf;
    };
    
    this.generateControl = function(CTLContainer,pCTLName)
    {
         this.GenrateCTL(CTLContainer,false,pCTLName);
    };
    
    this.generateControlJQObject = function(CTLContainer,pCTLName)
    {
         this.GenrateCTL(CTLContainer,true,pCTLName);
    };
        
    this.HC_Select_DataSelected = function(txt,vl,idx)
    {
        this.Text = this.Select.Text + ":" + this.TextBox.Text;
        this.Value = this.Select.Text + ":" + this.TextBox.Text;
    };
    
    this.HC_TextBox_KeyUp = function(e,txt)
    {
        this.Text = this.Select.Text + ":" + this.TextBox.Text;
        this.Value = this.Select.Text + ":" + this.TextBox.Text;
    };
    
    this.getText = function()
    {
        return this.Select.Text + ":" + this.TextBox.Text;
    };
    
    this.TextBoxKeyDown = function(e,txt)
    {
        try{
            this.ParentClassV.HC_TextBox_KeyDown(e,txt);
        }catch(e){} 
    };
    
    this.setSTText = function(txt)
    {
        this.STText = txt;
        this.TextBoxST.setText(txt);
    };
    
    this.setENText = function(txt)
    {
        this.ENText = txt;
        this.TextBoxEN.setText(txt);
    };
    
    this.setSTSelectText = function(txt)
    {
        this.SelectST.setText(txt);
    };
    
    this.setENSelectText = function(txt)
    {
        this.SelectEN.setText(txt);
    };
    
    this.clearAll = function()
    {
        this.setText("");
        this.setValue("");
        $('#'+this.CTLName).removeClass("is-valid");
        this.TextBox.setText("");
        this.TextBox.setValue("");
        this.Select.setText("");
        this.Select.setValue("");
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
                window[this.CTLName+"_gotoNextControl"](this.CTLName,this.NextControl);
            }catch(e){};
            
            try{
                if(this.ParentClassV!==null){
                    this.ParentClassV.gotoNextControl(this.CTLName,this.NextControl);
                }
            }catch(e){alert(e);};
        }
    };
    
    this.RemoveControl = function()
    {
        $("#"+this.CTLName+ "_container").remove();
    };
    
    this.setLabel = function(pLabel)
    {
        this.Label.setLabel(pLabel);
    };
    
    this.setShowLabel = function(tf)
    {
        this.TextBox.setShowLabel(tf);
    };
    
    this.setPlaceHolder = function(pPlaceHolder)
    {
        this.TextBox.setPlaceHolder(pPlaceHolder);
    };
  
    this.setBSColumn = function(ln)
    {
        var id = this.CTLName;
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
};


function HC_Date_Query(CTLName,pParentClassV)
{
    this.CTLName = CTLName || "";
    this.STText = "";
    this.ENText = "";
    this.ParentClassV = pParentClassV || null;
    this.NextControl = null;
    this.Label = new HC_Label(CTLName+"_Qlabel");
    this.TextBoxST = new HC_DatePicker(CTLName+"_textst",this);
    this.SelectST = new HC_Select(CTLName+"_selectst",[],this);
    this.TextBoxEN = new HC_DatePicker(CTLName+"_texten",this);
    this.SelectEN = new HC_Select(CTLName+"_selecten",[],this);
    this.Hidden = new HC_Hidden(CTLName);
    this.BSEnable = false;
    this.BSColumn = "";
    
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
         
         var dv = "<div id='" + id + "_container' class='input-group mb-2 input-group-sm' style='height:30px;'></div>";
         
         if(ObjTF===false)
            $("#" + CTLContainer).append(dv);
         else
             CTLContainer.append(dv);
         
         var dv = $("#"+id+"_container");
                  
         this.Label.generateControlJQObject(dv);
         
         this.SelectST.generateControlJQObject(dv);
         this.SelectST.Select.setShowLabel(false);
         var sl = $("#"+this.CTLName+"_selectst");
         sl.prop("id",id+"_selectst");
         $("#"+this.CTLName+"_selectst_container").remove();
         dv.append(sl);
         this.SelectST.Select.setupEvents();
         
         this.SelectST.addRow("","");
         this.SelectST.addRow("=","=");
         this.SelectST.addRow("<","<");
         this.SelectST.addRow(">",">");
         this.SelectST.addRow("<=","<=");
         this.SelectST.addRow(">=",">=");
         
         this.TextBoxST.generateControlJQObject(dv);
         this.TextBoxST.TextBox.Label.setShowLabel(false);
         
         var tb = $("#"+this.CTLName+"_textst");
         tb.prop("id",id+"_textst");
         var dvst = $("#"+this.CTLName+"_textst_DatePicker");
         dvst.prop("id",id+"_textst_DatePicker");
         $("#"+this.CTLName+"_textst_container").remove();
         dv.append(tb);
         dv.append(dvst);
         this.TextBoxST.TextBox.setupEvents();
         
         $("#"+this.CTLName+"_selectst").addClass("col-sm-2");
         $("#"+this.CTLName+"_textst").addClass("col-sm-4");

          //end section
        
         this.SelectEN.generateControlJQObject(dv);
         this.SelectEN.Select.setShowLabel(false);
         var sl = $("#"+this.CTLName+"_selecten");
         sl.prop("id",id+"_selecten");
         $("#"+this.CTLName+"_selecten_container").remove();
         dv.append(sl);
         this.SelectEN.Select.setupEvents();
         
         this.SelectEN.addRow("","");
         this.SelectEN.addRow("=","=");
         this.SelectEN.addRow("<","<");
         this.SelectEN.addRow(">",">");
         this.SelectEN.addRow("<=","<=");
         this.SelectEN.addRow(">=",">=");
         
         this.TextBoxEN.generateControlJQObject(dv);
         this.TextBoxEN.TextBox.Label.setShowLabel(false);
         var tb = $("#"+this.CTLName+"_texten");
         tb.prop("id",id+"_texten");
         var dven = $("#"+this.CTLName+"_texten_DatePicker");
         dven.prop("id",id+"_texten_DatePicker");
         $("#"+this.CTLName+"_texten_container").remove();
         dv.append(tb);
         dv.append(dven);
         this.TextBoxEN.TextBox.setupEvents();
         
         $("#"+this.CTLName+"_selecten").addClass("col-sm-2");
         $("#"+this.CTLName+"_texten").addClass("col-sm-4");
         
         this.Hidden.generateControlJQObject(dv);
         this.setBS(true);
         
    };
    
    this.setBS = function(tf)
    {
        this.Label.setBS(tf);
        this.TextBoxST.TextBox.setBS(tf);
        this.TextBoxEN.TextBox.setBS(tf);
        this.BSEnable = tf;
    };
    
    this.generateControl = function(CTLContainer,pCTLName)
    {
         this.GenrateCTL(CTLContainer,false,pCTLName);
    };
    
    this.generateControlJQObject = function(CTLContainer,pCTLName)
    {
        this.GenrateCTL(CTLContainer,true,pCTLName);
    };
        
    this.HC_Select_DataSelected = function(txt,vl,idx)
    {
        this.Text = this.Select.Text + ":" + this.TextBox.Text;
        this.Value = this.Select.Text + ":" + this.TextBox.Text;
    };
    
    this.HC_TextBox_KeyUp = function(e,txt)
    {
        this.Text = this.Select.Text + ":" + this.TextBox.Text;
        this.Value = this.Select.Text + ":" + this.TextBox.Text;
    };
    
    this.getText = function()
    {
        return this.Select.Text + ":" + this.TextBox.Text;
    };
    
    this.TextBoxKeyDown = function(e,txt)
    {
        try{
            this.ParentClassV.HC_TextBox_KeyDown(e,txt);
        }catch(e){} 
    };
    
    this.setSTText = function(txt)
    {
        this.STText = txt;
        this.TextBoxST.setText(txt);
    };
    
    this.setENText = function(txt)
    {
        this.ENText = txt;
        this.TextBoxEN.setText(txt);
    };
    
    this.setSTSelectText = function(txt)
    {
        this.SelectST.setText(txt);
    };
    
    this.setENSelectText = function(txt)
    {
        this.SelectEN.setText(txt);
    };
    
    this.clearAll = function()
    {
        this.setText("");
        this.setValue("");
        $('#'+this.CTLName).removeClass("is-valid");
        this.TextBox.setText("");
        this.TextBox.setValue("");
        this.Select.setText("");
        this.Select.setValue("");
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
                window[this.CTLName+"_gotoNextControl"](this.CTLName,this.NextControl);
            }catch(e){};
            
            try{
                if(this.ParentClassV!==null){
                    this.ParentClassV.gotoNextControl(this.CTLName,this.NextControl);
                }
            }catch(e){alert(e);};
        }
    };
    
    this.RemoveControl = function()
    {
        $("#"+this.CTLName+ "_container").remove();
    };
    
    this.setLabel = function(pLabel)
    {
        this.Label.setLabel(pLabel);
    };
    
    this.setShowLabel = function(tf)
    {
        this.TextBox.setShowLabel(tf);
    };
    
    this.setPlaceHolder = function(pPlaceHolder)
    {
        this.TextBox.setPlaceHolder(pPlaceHolder);
    };
  
    this.setBSColumn = function(ln)
    {
        var id = this.CTLName;
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
};

