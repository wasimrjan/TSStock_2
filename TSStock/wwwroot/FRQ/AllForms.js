/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

//System Organization Starts

try {

    var fmCategories = new HC_Forms("fmCategories");
    jsonCategories = [
        { cnm: "catid", width: "150", lbl: "Category ID", placeholder: "", ctp: "TB", required: "N", vtp: "S", validERR: "", ro: "Y", maxlen: "", nextctl: "mttp", json: "", ajaxid: "", selidcol: "", selcol: "", showcol: "", whcol: "", row: "", bscol: "", group: "", tab: "", tabtitle: "" },
        { cnm: "cat", width: "450", lbl: "Category", placeholder: "", ctp: "TB", required: "Y", vtp: "S", validERR: "", ro: "N", maxlen: "", nextctl: "mttp", json: "", ajaxid: "", selidcol: "", selcol: "", showcol: "", whcol: "", row: "", bscol: "", group: "", tab: "", tabtitle: "" }
    ];

    fmCategories.Heading = "New Category Entry Screen";
    fmCategories.WhereColumn = "catid";
    fmCategories.AssignFields(JSON.stringify(jsonCategories));
    fmCategories.FirstFocusControl = "cat";
    fmCategories.SearchColumns = "catid,cat";
    //fmMaterialType.ExternalValidationEnable = true;

} catch (e) { alert(e); }


try{
                            
    var fmMaterialType = new HC_Forms("fmMaterialType");
    jsonMaterialType = [
        {cnm:"id",width:"150",lbl:"Matrial Type ID",placeholder:"",ctp:"TB",required:"N",vtp:"S",validERR:"",ro:"Y",maxlen:"",nextctl:"mttp",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"",bscol:"",group:"",tab:"",tabtitle:""},
        {cnm:"mttp",width:"450",lbl:"Material Type",placeholder:"",ctp:"TB",required:"Y",vtp:"S",validERR:"",ro:"N",maxlen:"",nextctl:"mttp",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"",bscol:"",group:"",tab:"",tabtitle:""}
    ];

    fmMaterialType.Heading = "New Material Type Screen";
    fmMaterialType.WhereColumn = "id";
    fmMaterialType.AssignFields(JSON.stringify(jsonMaterialType));
    fmMaterialType.FirstFocusControl = "mttp";
    fmMaterialType.SearchColumns = "id,mttp";
    //fmMaterialType.ExternalValidationEnable = true;

}catch(e){alert(e);}


try{
                            
    var fmSubLocation = new HC_Forms("fmSubLocation");
    jsonSubLocation = [
        {cnm:"id",width:"150",lbl:"Sub Location ID",placeholder:"",ctp:"TB",required:"N",vtp:"S",validERR:"",ro:"Y",maxlen:"",nextctl:"mttp",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"",bscol:"",group:"",tab:"",tabtitle:""},
        {cnm:"sloc",width:"450",lbl:"Sub Location",placeholder:"",ctp:"TB",required:"Y",vtp:"S",validERR:"",ro:"N",maxlen:"",nextctl:"mttp",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"",bscol:"",group:"",tab:"",tabtitle:""}
    ];

    fmSubLocation.Heading = "New Sub Location Screen";
    fmSubLocation.WhereColumn = "id";
    fmSubLocation.AssignFields(JSON.stringify(jsonSubLocation));
    fmSubLocation.FirstFocusControl = "sloc";
    fmSubLocation.SearchColumns = "id,sloc";
    //fmMaterialType.ExternalValidationEnable = true;

}catch(e){alert(e);}



try{
                            
    var fmRack = new HC_Forms("fmRack");
    jsonRack = [
        {cnm:"id",width:"150",lbl:"Rack ID",placeholder:"",ctp:"TB",required:"N",vtp:"S",validERR:"",ro:"Y",maxlen:"",nextctl:"mttp",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"",bscol:"",group:"",tab:"",tabtitle:""},
        {cnm:"ssloc",width:"450",lbl:"Rack",placeholder:"",ctp:"TB",required:"Y",vtp:"S",validERR:"",ro:"N",maxlen:"",nextctl:"mttp",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"",bscol:"",group:"",tab:"",tabtitle:""}
    ];

    fmRack.Heading = "New Rack Entry Screen";
    fmRack.WhereColumn = "id";
    fmRack.AssignFields(JSON.stringify(jsonRack));
    fmRack.FirstFocusControl = "ssloc";
    fmRack.SearchColumns = "id,ssloc";
    //fmMaterialType.ExternalValidationEnable = true;

}catch(e){alert(e);}


try{
                            
    var fmStockOutEmp = new HC_Forms("fmStockOutEmp");
    jsonStockOutEmp = [
        {cnm:"id",width:"150",lbl:"Rack ID",placeholder:"",ctp:"TB",required:"N",vtp:"S",validERR:"",ro:"Y",maxlen:"",nextctl:"pno",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"",bscol:"",group:"",tab:"",tabtitle:""},
        {cnm:"pno",width:"150",lbl:"Personal No.",placeholder:"",ctp:"TB",required:"Y",vtp:"S",validERR:"",ro:"N",maxlen:"",nextctl:"enm",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"",bscol:"",group:"",tab:"",tabtitle:""},
        {cnm:"enm",width:"450",lbl:"Employee",placeholder:"",ctp:"TB",required:"Y",vtp:"S",validERR:"",ro:"N",maxlen:"",nextctl:"enm",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"",bscol:"",group:"",tab:"",tabtitle:""}
    ];

    fmStockOutEmp.Heading = "New Stock Issue Employees Screen";
    fmStockOutEmp.WhereColumn = "id";
    fmStockOutEmp.AssignFields(JSON.stringify(jsonStockOutEmp));
    fmStockOutEmp.FirstFocusControl = "pno";
    fmStockOutEmp.SearchColumns = "id,pno,enm";
    //fmMaterialType.ExternalValidationEnable = true;

}catch(e){alert(e);}


try{
                            
    var fmLocation = new HC_Forms("fmLocation");
    jsonLocation = [
        {cnm:"id",width:"100",lbl:"Location ID",placeholder:"",ctp:"TB",required:"N",vtp:"S",validERR:"",ro:"Y",maxlen:"",nextctl:"orz",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"",bscol:"",group:"",tab:"",tabtitle:""},
        {cnm:"loc",width:"350",lbl:"Location",placeholder:"",ctp:"TB",required:"Y",vtp:"S",validERR:"",ro:"N",maxlen:"",nextctl:"adds",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"",bscol:"",group:"",tab:"",tabtitle:""}
    ];

    fmLocation.Heading = "New Location Entry";
    fmLocation.WhereColumn = "id";
    fmLocation.AssignFields(JSON.stringify(jsonLocation));
    fmLocation.FirstFocusControl = "loc";
    fmLocation.SearchColumns = "id,loc";
    fmLocation.ExternalValidationEnable = true;

}catch(e){alert(e);}

try{
                            
    var fmUser = new HC_Forms("fmUser");
    jsonUser = [
        {cnm:"id",width:"100",lbl:"ID",placeholder:"",ctp:"TB",required:"N",vtp:"S",validERR:"",ro:"Y",maxlen:"",nextctl:"orz",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"",bscol:"",group:"",tab:"",tabtitle:""},
        {cnm:"uid",width:"100",lbl:"User ID",placeholder:"",ctp:"TB",required:"Y",vtp:"S",validERR:"",ro:"N",maxlen:"",nextctl:"unm",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"",bscol:"",group:"",tab:"",tabtitle:""},
        {cnm:"unm",width:"120",lbl:"User Name",placeholder:"",ctp:"TB",required:"Y",vtp:"S",validERR:"",ro:"N",maxlen:"",nextctl:"utp",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"",bscol:"",group:"",tab:"",tabtitle:""},
        {cnm:"utp",width:"120",lbl:"User ID",placeholder:"",ctp:"ACList",required:"Y",vtp:"S",validERR:"",ro:"N",maxlen:"",nextctl:"loc",json:[{"utp":"Admin"},{"utp":"User"}],ajaxid:"",selidcol:"utp",selcol:"utp",showcol:"utp",whcol:"utp",row:"",bscol:"",group:"",tab:"",tabtitle:"",ACColWidth:"0:300,W:230,H:200"},
        {cnm:"loc",width:"120",lbl:"Location",placeholder:"",ctp:"ACList",required:"",vtp:"S",validERR:"",ro:"N",maxlen:"",nextctl:"loc",json:"",ajaxid:"lstLoc",selidcol:"loc",selcol:"loc",showcol:"loc",whcol:"loc",row:"",bscol:"",group:"",tab:"",tabtitle:"",ACColWidth:"0:300,W:230,H:200"}
    ];

    fmUser.Heading = "New User Entry";
    fmUser.WhereColumn = "id";
    fmUser.AssignFields(JSON.stringify(jsonUser));
    fmUser.FirstFocusControl = "uid";
    fmUser.SearchColumns = "uid,unm,loc";
    fmUser.ExternalValidationEnable = true;

}catch(e){alert(e);}


try{
                            
    jsonStockDetails = [
        {cnm:"itid",width:"100",lbl:"Item ID",placeholder:"",ctp:"TB",required:"Y",vtp:"S",validERR:"",ro:"N",maxlen:"",nextctl:"unm",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"R1",bscol:"2",group:"",tab:"",tabtitle:""},
        {cnm:"mtcd",width:"120",lbl:"UMC No",placeholder:"",ctp:"TB",required:"Y",vtp:"S",validERR:"",ro:"N",maxlen:"",nextctl:"utp",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"R1",bscol:"4",group:"",tab:"",tabtitle:""},
        {cnm:"material",width:"120",lbl:"Material",placeholder:"",ctp:"TB",required:"Y",vtp:"S",validERR:"",ro:"N",maxlen:"",nextctl:"utp",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"R1",bscol:"6",group:"",tab:"",tabtitle:""},
        {cnm:"make",width:"120",lbl:"Make",placeholder:"",ctp:"TB",required:"Y",vtp:"S",validERR:"",ro:"N",maxlen:"",nextctl:"utp",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"R2",bscol:"6",group:"",tab:"",tabtitle:""},
        {cnm:"uom",width:"120",lbl:"UOM",placeholder:"",ctp:"TB",required:"Y",vtp:"S",validERR:"",ro:"N",maxlen:"",nextctl:"utp",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"R2",bscol:"3",group:"",tab:"",tabtitle:""},
        {cnm:"skid",width:"120",lbl:"Stock ID",placeholder:"",ctp:"TB",required:"Y",vtp:"S",validERR:"",ro:"N",maxlen:"",nextctl:"utp",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"R2",bscol:"3",group:"",tab:"",tabtitle:""},
        {cnm:"loc",width:"120",lbl:"Location",placeholder:"",ctp:"TB",required:"Y",vtp:"S",validERR:"",ro:"N",maxlen:"",nextctl:"utp",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"R3",bscol:"6",group:"",tab:"",tabtitle:""},
        {cnm:"sloc",width:"120",lbl:"Sub Location",placeholder:"",ctp:"TB",required:"Y",vtp:"S",validERR:"",ro:"N",maxlen:"",nextctl:"utp",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"R3",bscol:"3",group:"",tab:"",tabtitle:""},
        {cnm:"ssloc",width:"120",lbl:"Rack",placeholder:"",ctp:"TB",required:"Y",vtp:"S",validERR:"",ro:"N",maxlen:"",nextctl:"utp",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"R3",bscol:"3",group:"",tab:"",tabtitle:""}
    ];

    
}catch(e){alert(e);}



try{
                            
    var fmStockItem = new HC_Forms("fmStockItem");
    jsonStockItem = [
        {cnm:"id",width:"100",lbl:"ID",placeholder:"",ctp:"TB",required:"N",vtp:"S",validERR:"",ro:"Y",maxlen:"",nextctl:"mtcd",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"R0",bscol:"6",group:"",tab:"",tabtitle:""},
        {cnm:"mtcd",width:"120",lbl:"UMC No",placeholder:"",ctp:"TB",required:"N",vtp:"S",validERR:"",ro:"N",maxlen:"",nextctl:"material",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"R0",bscol:"6",group:"",tab:"",tabtitle:"",ACColWidth:""},
        {cnm:"material",width:"250",lbl:"Material",placeholder:"",ctp:"TB",required:"Y",vtp:"S",validERR:"",ro:"N",maxlen:"",nextctl:"ittp",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"loc",row:"R1",bscol:"6",group:"",tab:"",tabtitle:"",ACColWidth:""},
        {cnm:"ittp",width:"120",lbl:"Type",placeholder:"",ctp:"ACList",required:"N",vtp:"S",validERR:"",ro:"N",maxlen:"",nextctl:"rating",json:"",ajaxid:"lstItemTP",selidcol:"ittp",selcol:"ittp",showcol:"ittp",whcol:"ittp",row:"R1",bscol:"6",group:"",tab:"",tabtitle:"",ACColWidth:"0:300,W:230,H:200"},
        {cnm:"rating",width:"120",lbl:"Rating",placeholder:"",ctp:"ACList",required:"N",vtp:"S",validERR:"",ro:"N",maxlen:"",nextctl:"make",json:"",ajaxid:"lstItemRating",selidcol:"rating",selcol:"rating",showcol:"rating",whcol:"rating",row:"R2",bscol:"4",group:"",tab:"",tabtitle:"",ACColWidth:"0:300,W:230,H:200"},
        {cnm:"make",width:"120",lbl:"Make",placeholder:"",ctp:"ACList",required:"N",vtp:"S",validERR:"",ro:"N",maxlen:"",nextctl:"uom",json:"",ajaxid:"lstItemMake",selidcol:"make",selcol:"make",showcol:"make",whcol:"make",row:"R2",bscol:"4",group:"",tab:"",tabtitle:"",ACColWidth:"0:300,W:230,H:200"},
        {cnm:"uom",width:"80",lbl:"UOM",placeholder:"",ctp:"ACList",required:"Y",vtp:"S",validERR:"",ro:"N",maxlen:"",nextctl:"omtcd",json:"",ajaxid:"lstUOM",selidcol:"uom",selcol:"uom",showcol:"uom",whcol:"uom",row:"R2",bscol:"4",group:"",tab:"",tabtitle:"",ACColWidth:"0:200,W:230,H:200"},
        {cnm:"omtcd",width:"120",lbl:"Old UMC No",placeholder:"",ctp:"TB",required:"N",vtp:"S",validERR:"",ro:"N",maxlen:"",nextctl:"appl",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"R3",bscol:"6",group:"",tab:"",tabtitle:""},
        {cnm:"appl",width:"80",lbl:"Application",placeholder:"",ctp:"ACList",required:"N",vtp:"S",validERR:"",ro:"N",maxlen:"",nextctl:"wlvl",json:"",ajaxid:"lstAppl",selidcol:"appl",selcol:"appl",showcol:"appl",whcol:"appl",row:"R3",bscol:"6",group:"",tab:"",tabtitle:"",ACColWidth:"0:200,W:230,H:200"},
        {cnm:"wlvl",width:"90",lbl:"Warning Lvl",placeholder:"",ctp:"TB",required:"N",vtp:"S",validERR:"",ro:"N",maxlen:"",nextctl:"rlvl",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"R4",bscol:"4",group:"",tab:"",tabtitle:"",ACColWidth:""},
        {cnm:"rlvl",width:"90",lbl:"Re-Order Lvl",placeholder:"",ctp:"TB",required:"N",vtp:"S",validERR:"",ro:"N",maxlen:"",nextctl:"critical",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"loc",row:"R4",bscol:"4",group:"",tab:"",tabtitle:"",ACColWidth:""},
        {cnm:"critical",width:"70",lbl:"Critical",placeholder:"",ctp:"ACList",required:"Y",vtp:"S",validERR:"",ro:"N",maxlen:"",nextctl:"descp",json:[{"crit":"N"},{"crit":"Y"}],ajaxid:"",selidcol:"crit",selcol:"crit",showcol:"crit",whcol:"crit",row:"R4",bscol:"4",group:"",tab:"",tabtitle:"",ACColWidth:"0:300,W:230,H:200"},
        {cnm:"descp",width:"350",lbl:"Description",placeholder:"",ctp:"TB",required:"N",vtp:"S",validERR:"",ro:"N",maxlen:"",nextctl:"descp",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"",bscol:"",group:"",tab:"",tabtitle:"",ACColWidth:""},
        {cnm:"sts",width:"60",lbl:"Status",placeholder:"",ctp:"TB",required:"N",vtp:"S",validERR:"",ro:"Y",maxlen:"",nextctl:"sts",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"R5",bscol:"6",group:"",tab:"",tabtitle:""},
        {cnm:"cdt",width:"90",lbl:"Date",placeholder:"",ctp:"TB",required:"N",vtp:"S",validERR:"",ro:"Y",maxlen:"",nextctl:"cdt",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"R5",bscol:"3",group:"",tab:"",tabtitle:""},
        {cnm:"cby",width:"90",lbl:"User ID",placeholder:"",ctp:"TB",required:"N",vtp:"S",validERR:"",ro:"Y",maxlen:"",nextctl:"cby",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"R5",bscol:"3",group:"",tab:"",tabtitle:""}
    ];

    fmStockItem.Heading = "New Stock Item";
    fmStockItem.WhereColumn = "id";
    fmStockItem.AssignFields(JSON.stringify(jsonStockItem));
    fmStockItem.FirstFocusControl = "mtcd";
    fmStockItem.SearchColumns = "mtcd,material";
    fmStockItem.ExternalValidationEnable = true;
    
    
    function fmStockItem_Open(cnt,fptp){
        fmStockItem.GridView.enablePaging(10)
        
        if(fptp=="Open_Form_New" || fptp=="Open_Form_Edit_JSON")
        {
          
            fmStockItem.getControlKey("sts").setText("Active");
            fmStockItem.getControlKey("cdt").setText(GP.sysdate);
            fmStockItem.getControlKey("cby").setText(GP.uid);
            fmStockItem.getControlKey("ittp").ComboBox = true;
            fmStockItem.getControlKey("rating").ComboBox = true;
            fmStockItem.getControlKey("uom").ComboBox = true;
            fmStockItem.getControlKey("appl").ComboBox = true;
            fmStockItem.getControlKey("make").ComboBox = true;
            
        }
    }
    
    function fmStockItem_ExternalValidation()
    {
        if(fmStockItem.getControlKey("mtcd").Text!=""){
            if(!checkUMC_Format(fmStockItem.getControlKey("mtcd").Text)){
                alert("Please Check UMC number format use the following format (0000A0000).");
                fmStockItem.getControlKey("mtcd").setFocus();
                return false;
            }
            else
                return true;
        }
        else
            return true;
    }

}catch(e){alert(e);}




try{
                            
    var fmStockIN = new HC_TransactionForms("fmStockIN");
    jsonStockIN = [
        {cnm:"id",width:"80",lbl:"ID",placeholder:"",ctp:"TB",required:"N",vtp:"S",validERR:"",ro:"Y",maxlen:"",nextctl:"descp",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"R0",bscol:"6",group:"",tab:"",tabtitle:""},
        {cnm:"loc",width:"60",lbl:"Location",placeholder:"",ctp:"TB",required:"Y",vtp:"S",validERR:"",ro:"Y",maxlen:"",nextctl:"descp",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",ACColWidth:"",row:"R0",bscol:"6",group:"",tab:"",tabtitle:""},
        {cnm:"descp",width:"80",lbl:"Description",placeholder:"",ctp:"TB",required:"N",vtp:"S",validERR:"",ro:"N",maxlen:"",nextctl:"GridView",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"",bscol:"",group:"",tab:"",tabtitle:"",ACColWidth:""},
        {cnm:"dt",width:"90",lbl:"Stock Date",placeholder:"",ctp:"TBDate",required:"N",vtp:"S",validERR:"",ro:"N",maxlen:"",nextctl:"GridView",json:"",ajaxid:"",selidcol:"id",selcol:"",showcol:"",whcol:"",row:"R1",bscol:"3",group:"",tab:"",tabtitle:"",ACColWidth:""},
        {cnm:"cdt",width:"90",lbl:"Create Date",placeholder:"",ctp:"TB",required:"N",vtp:"S",validERR:"",ro:"Y",maxlen:"",nextctl:"GridView",json:"",ajaxid:"",selidcol:"id",selcol:"",showcol:"",whcol:"",row:"R1",bscol:"3",group:"",tab:"",tabtitle:"",ACColWidth:""},
        {cnm:"cby",width:"90",lbl:"Create ID",placeholder:"",ctp:"TB",required:"N",vtp:"S",validERR:"",ro:"Y",maxlen:"",nextctl:"GridView",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",ACColWidth:"",row:"R1",bscol:"3",group:"",tab:"",tabtitle:""},
        {cnm:"cnm",width:"90",lbl:"Create Name",placeholder:"",ctp:"TB",required:"N",vtp:"S",validERR:"",ro:"Y",maxlen:"",nextctl:"GridView",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",ACColWidth:"",row:"R1",bscol:"3",group:"",tab:"",tabtitle:""}
   ];

    
    fmStockIN.Form.Heading = "Stock in Items";
    fmStockIN.Form.WhereColumn = "id";
    fmStockIN.Form.AssignFields(JSON.stringify(jsonStockIN));
    fmStockIN.Form.FirstFocusControl = "dt";
    fmStockIN.Form.SearchColumns = "id";
    fmStockIN.PrimaryColumn = "id";
    fmStockIN.Form.ExternalValidationEnable = true;
    fmStockIN.Form.ModalType = "XL";
    
    jsonTranStockIN = [
        {editable:"Y",required:"Y",width:"150",cnm:"itid",lbl:"Item ID",ctp:"ACList",vtp:"S",maxlen:"",json:"",ajaxid:"",selidcol:"itid",selcol:"itid",showcol:"itid,mtcd,material,avl,critical,uom,make,skid",whcol:"mtcd,material",ACColWidth:"0:70,1:120,2:180,3:100,H:250,W:850"},
        {editable:"N",required:"N",width:"90",cnm:"mtcd",lbl:"UMC No",ctp:"TB",vtp:"S",maxlen:"",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",ACColWidth:""},
        {editable:"N",required:"N",width:"380",cnm:"material",lbl:"Material",ctp:"TB",vtp:"S",maxlen:"",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",ACColWidth:""},
        {editable:"Y",required:"N",width:"180",cnm:"make",lbl:"Make",ctp:"ACList",vtp:"S",maxlen:"",json:"",ajaxid:"",selidcol:"make",selcol:"make",showcol:"make",whcol:"make",ACColWidth:"0:250,H:100,W:300"},
        {editable:"Y",required:"N",width:"150",cnm:"sloc",lbl:"Sub Loc",ctp:"ACList",vtp:"S",maxlen:"",json:"",ajaxid:"",selidcol:"sloc",selcol:"sloc",showcol:"sloc",whcol:"sloc",ACColWidth:"0:250,H:100,W:300"},
        {editable:"Y",required:"N",width:"130",cnm:"ssloc",lbl:"Rack",ctp:"ACList",vtp:"S",maxlen:"",json:"",ajaxid:"",selidcol:"ssloc",selcol:"ssloc",showcol:"ssloc",whcol:"ssloc",ACColWidth:"0:250,H:100,W:300"},
        {editable:"Y",required:"Y",width:"70",cnm:"qty",lbl:"Qty",ctp:"TB",vtp:"D",maxlen:"",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:""},
        {editable:"N",required:"N",width:"80",cnm:"critical",lbl:"Critical",ctp:"TB",vtp:"S",maxlen:"",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",ACColWidth:""},
        {editable:"N",required:"N",width:"70",cnm:"uom",lbl:"UOM",ctp:"TB",vtp:"S",maxlen:"",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",ACColWidth:""},
        {editable:"N",required:"N",width:"80",cnm:"skid",lbl:"Stock ID",ctp:"TB",vtp:"S",maxlen:"",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",ACColWidth:""},
        {editable:"N",required:"N",width:"80",cnm:"avl",lbl:"Available",ctp:"TB",vtp:"S",maxlen:"",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",ACColWidth:""}
     ];

     fmStockIN.TranGridJSON = jsonTranStockIN;

     function fmStockIN_ExternalValidation()
     {
        return fmStockIN.TranGridView.validateGridView();
     }

     function fmStockIN_Open(cnt,msg)
     {
        fmStockIN.TranGridView.GridView.SelectMode = "C";
        fmStockIN.TranGridView.GridView.setGridViewHeight(400);
        (new HC_DelayCall()).Call(function(){
            fmStockIN.Form.getControlKey("loc").setText(GP.loc);
            fmStockIN.Form.getControlKey("dt").setText(GP.sysdate);
            fmStockIN.Form.getControlKey("cdt").setText(GP.sysdate);
            fmStockIN.Form.getControlKey("cby").setText(GP.uid);
            fmStockIN.Form.getControlKey("cnm").setText(GP.unm);
        });
        
        fmStockIN.TranGridView.GridView.setDefaultWidth(true);
        fmStockIN.TranGridView.GridView.setScrollBarY(true);
        fmStockIN.TranGridView.GridView.setScrollBarX(true);
        
        if(msg=="Open_Form_Modal_KEY_ReadOnly"){
     
            fmStockIN.TranGridView.GridView.setSearching(); 
            fmStockIN.TranGridView.GridView.enablePaging(6);
            
       
        }
        
     }
     
     function fmStockIN_SaveFormEnd()
     {
        alert("Stock In Process Successfully Completed . . . Please check your stock"); 
        location.reload();
     }
     
     
     function fmStockIN_inList(json,ri){
         var itid,mtcd,material,make,loc,sloc,ssloc,critical;
         if(json.material!=""){
            for(var i=0;i<fmStockIN.TranGridView.GridView.getRowLength();i++){
                if(i!=ri){
                itid = fmStockIN.TranGridView.GridView.getHTMLKey(i,"itid");
                mtcd = fmStockIN.TranGridView.GridView.getHTMLKey(i,"mtcd");
                material = fmStockIN.TranGridView.GridView.getHTMLKey(i,"material");
                make = fmStockIN.TranGridView.GridView.getHTMLKey(i,"make");
                sloc = fmStockIN.TranGridView.GridView.getHTMLKey(i,"sloc");
                ssloc = fmStockIN.TranGridView.GridView.getHTMLKey(i,"ssloc");
                critical = fmStockIN.TranGridView.GridView.getHTMLKey(i,"critical");
                
                if(itid==json.itid && mtcd==json.mtcd && material==json.material && make==json.make && sloc==json.sloc && ssloc==json.ssloc && critical==json.critical)
                    return true;
                }
            }
         }
         return false;
     }
     
     
     function fmStockIN_TranGridView_DataSelected(r,c,json){
         
         if(c==0){
             if(json!=null){
                if(!fmStockIN_inList(json,r)){
                    if(json.material!=""){
                        fmStockIN.TranGridView.GridView.setHTML(r,1,json.mtcd);
                        fmStockIN.TranGridView.GridView.setHTML(r,2,json.material);
                        fmStockIN.TranGridView.GridView.setHTMLKey(r,"critical",json.critical);
                        fmStockIN.TranGridView.GridView.setHTMLKey(r,"uom",json.uom);
                        fmStockIN.TranGridView.GridView.setHTMLKey(r,"make",json.make);
                        fmStockIN.TranGridView.GridView.setHTMLKey(r,"skid",json.skid);
                        fmStockIN.TranGridView.GridView.setHTMLKey(r,"sloc",json.sloc);
                        fmStockIN.TranGridView.GridView.setHTMLKey(r,"ssloc",json.ssloc);
                        fmStockIN.TranGridView.GridView.setHTMLKey(r,"avl",json.avl);
                    }
                }
                else{
                    alert("Material Already Selected In List Please Choose Another Material");
                    (new HC_DelayCall()).Call(function(){
                        fmStockIN.TranGridView.setFocusGridView(r,0);
                    });
                }
             }
         }
         
         
         
     }
     
     function fmStockIN_TranGridView_MatrixEnter(r,c,ctl){
         if(c==0){
             var aj = new HC_Ajax("lstStockItem");
             aj.CallServer(function(data){
                 ctl.GridView.enablePaging(5);
                 ctl.GridView.populateUsingJSON_Blank(data);
             });
         }
         if(c==3 || c==4 || c==5)
             //ctl.ComboBox = true;
             
             if(c==3){
                ctl.ComboBox = true; 
                var vl = ctl.Text;
                var aj = new HC_Ajax("lstMake");
                aj.CallServer(function(data){
                    ctl.GridView.enablePaging(5);
                    ctl.GridView.populateUsingJSON(data);
                    ctl.setText(vl);
                });
             }
             
             if(c==4){
                var vl = ctl.Text;
                var aj = new HC_Ajax("lstSubLoc");
                aj.addFormData("loc",GP.loc,GP.loc);
                aj.CallServer(function(data){
                    ctl.GridView.enablePaging(5);
                    ctl.GridView.populateUsingJSON_Blank(data);
                    ctl.setText(vl);
                });
             }
             
             if(c==5){
                var vl = ctl.Text;
                var aj = new HC_Ajax("lstSubSubLoc");
                aj.addFormData("loc",GP.loc,GP.loc);
                aj.CallServer(function(data){
                    ctl.GridView.enablePaging(5);
                    ctl.GridView.populateUsingJSON_Blank(data);
                    ctl.setText(vl);
                });
             }
         
     }
     
     
     function fmStockIN_TranGridView_MatrixLeave(r,c,ctl){
         
         if(c==6){
                var qt;
                
                qt = eval(fmStockIN.TranGridView.GridView.getHTML(r,6));
                   
                if(qt<=0){
                    alert("Quantity cannot be 0 (Zero) or less : ");
                    (new HC_DelayCall()).Call(function(){
                        fmStockIN.TranGridView.setFocusGridView(r,6);
                    });
                }
                else
                if(qt>99999){
                    alert("Quantity cannot be greater than 99,999 ");
                    (new HC_DelayCall()).Call(function(){
                        fmStockIN.TranGridView.setFocusGridView(r,6);
                    });
                }
                
         }
         
         if(c==0)
         {
             if(ctl.GridView.getJSON().length==0){
                 var vl = ctl.Text;
                 alert("Invalid Item Selected : ");
                 (new HC_DelayCall()).Call(function(){
                    fmStockIN.TranGridView.GridView.setHTML(r,0,vl); 
                    fmStockIN.TranGridView.setFocusGridView(r,0);
                 });
             }
         }
         
         
     }
     
}catch(e){alert(e);}



try{
                            
    var fmBookIN = new HC_TransactionForms("fmBookIN");
    jsonBookIN = [
        {cnm:"id",width:"80",lbl:"ID",placeholder:"",ctp:"TB",required:"N",vtp:"S",validERR:"",ro:"Y",maxlen:"",nextctl:"descp",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"",bscol:"",group:"",tab:"",tabtitle:""},
        {cnm:"descp",width:"80",lbl:"Description",placeholder:"",ctp:"TB",required:"N",vtp:"S",validERR:"",ro:"N",maxlen:"",nextctl:"dt",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"",bscol:"",group:"",tab:"",tabtitle:"",ACColWidth:""},
        {cnm:"dt",width:"90",lbl:"Stock Date",placeholder:"",ctp:"TBDate",required:"N",vtp:"S",validERR:"",ro:"N",maxlen:"",nextctl:"GridView",json:"",ajaxid:"",selidcol:"id",selcol:"",showcol:"",whcol:"",row:"",bscol:"",group:"",tab:"",tabtitle:"",ACColWidth:""}
   ];
    
    fmBookIN.Form.Heading = "Book In";
    fmBookIN.Form.WhereColumn = "id";
    fmBookIN.Form.AssignFields(JSON.stringify(jsonBookIN));
    fmBookIN.Form.FirstFocusControl = "descp";
    fmBookIN.Form.SearchColumns = "id";
    fmBookIN.PrimaryColumn = "id";
    fmBookIN.Form.ExternalValidationEnable = true;
    fmBookIN.Form.ModalType = "XL";
    
    jsonTranBookIN = [
        {editable:"Y",required:"Y",width:"350",cnm:"book",lbl:"Book",ctp:"TB",vtp:"S",maxlen:"",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",ACColWidth:""},
        {editable:"Y",required:"Y",width:"90",cnm:"qty",lbl:"Quantity",ctp:"TB",vtp:"S",maxlen:"",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",ACColWidth:""},
        {editable:"Y",required:"N",width:"90",cnm:"rate",lbl:"Rate",ctp:"TB",vtp:"S",maxlen:"",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",ACColWidth:""},
        {editable:"N",required:"N",width:"90",cnm:"tot",lbl:"Total",ctp:"TB",vtp:"S",maxlen:"",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",ACColWidth:""}
     ];

     fmBookIN.TranGridJSON = jsonTranBookIN;
     
     function fmBookIN_Open(cnt,msg,fptp)
     {
         //alert(fptp);
        //if(fptp=="Open_Form_New" || fptp=="Open_Form_Edit_JSON")
        //{
            fmBookIN.Form.getControlKey("dt").setText(GP.sysdate);
        //}
     }
     
     
     function fmBookIN_SaveFormEnd()
     {
        //alert("Stock In Process Successfully Completed . . . Please check your stock"); 
        location.reload();
     }
     
     
     function fmBookIN_TranGridView_MatrixLeave(r,c,ctl){
         
         if(c==2){
                var qt,rt;
                
                qt = eval(fmBookIN.TranGridView.GridView.getHTML(r,1));
                rt = eval(fmBookIN.TranGridView.GridView.getHTML(r,2));
                
                fmBookIN.TranGridView.GridView.setHTML(r,3,(qt*rt));
                
         }
     }
     
}catch(e){alert(e);}


try{
                            
    var fmStockOUT = new HC_TransactionForms("fmStockOUT");
    jsonStockOUT = [
        {cnm:"id",width:"80",lbl:"ID",placeholder:"",ctp:"TB",required:"N",vtp:"S",validERR:"",ro:"Y",maxlen:"",nextctl:"descp",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"R0",bscol:"6",group:"",tab:"",tabtitle:""},
        {cnm:"loc",width:"60",lbl:"Location",placeholder:"",ctp:"TB",required:"Y",vtp:"S",validERR:"",ro:"Y",maxlen:"",nextctl:"descp",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",ACColWidth:"",row:"R0",bscol:"6",group:"",tab:"",tabtitle:""},
        {cnm:"descp",width:"80",lbl:"Description",placeholder:"",ctp:"TB",required:"N",vtp:"S",validERR:"",ro:"N",maxlen:"",nextctl:"ispno",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"",bscol:"",group:"",tab:"",tabtitle:"",ACColWidth:""},
        {cnm:"ispno",width:"80",lbl:"Emp ID",placeholder:"",ctp:"ACList",required:"Y",vtp:"S",validERR:"",ro:"N",maxlen:"",nextctl:"isto",json:"",ajaxid:"lstIssueEmp",selidcol:"pno",selcol:"pno",showcol:"pno,enm",whcol:"pno,enm",row:"R1",bscol:"6",group:"",tab:"",tabtitle:"",ACColWidth:"0:150,1:350,W:520,H:200"},
        {cnm:"isto",width:"80",lbl:"Employee",placeholder:"",ctp:"TB",required:"Y",vtp:"S",validERR:"",ro:"N",maxlen:"",nextctl:"tknspno",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"R1",bscol:"6",group:"",tab:"",tabtitle:"",ACColWidth:""},
        {cnm:"tknspno",width:"80",lbl:"Taken by SPNo",placeholder:"",ctp:"ACList",required:"Y",vtp:"S",validERR:"",ro:"N",maxlen:"",nextctl:"tknby",json:"",ajaxid:"lstIssueCont",selidcol:"spno",selcol:"spno",showcol:"spno,ctnm",whcol:"spno,ctnm",row:"R2",bscol:"6",group:"",tab:"",tabtitle:"",ACColWidth:"0:140,1:150,W:300,H:200"},
        {cnm:"tknby",width:"80",lbl:"Taken by",placeholder:"",ctp:"TB",required:"Y",vtp:"S",validERR:"",ro:"N",maxlen:"",nextctl:"dt",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"R2",bscol:"6",group:"",tab:"",tabtitle:"",ACColWidth:""},
        {cnm:"dt",width:"90",lbl:"Stock Date",placeholder:"",ctp:"TBDate",required:"N",vtp:"S",validERR:"",ro:"N",maxlen:"",nextctl:"GridView",json:"",ajaxid:"",selidcol:"id",selcol:"",showcol:"",whcol:"",row:"R3",bscol:"3",group:"",tab:"",tabtitle:"",ACColWidth:""},
        {cnm:"cdt",width:"90",lbl:"Create Date",placeholder:"",ctp:"TB",required:"N",vtp:"S",validERR:"",ro:"Y",maxlen:"",nextctl:"GridView",json:"",ajaxid:"",selidcol:"id",selcol:"",showcol:"",whcol:"",row:"R3",bscol:"3",group:"",tab:"",tabtitle:"",ACColWidth:""},
        {cnm:"cby",width:"90",lbl:"Create ID",placeholder:"",ctp:"TB",required:"N",vtp:"S",validERR:"",ro:"Y",maxlen:"",nextctl:"GridView",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",ACColWidth:"",row:"R3",bscol:"3",group:"",tab:"",tabtitle:""},
        {cnm:"cnm",width:"90",lbl:"Create Name",placeholder:"",ctp:"TB",required:"N",vtp:"S",validERR:"",ro:"Y",maxlen:"",nextctl:"GridView",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",ACColWidth:"",row:"R3",bscol:"3",group:"",tab:"",tabtitle:""}
   ];

    fmStockOUT.Form.Heading = "Stock Out Items (Stock Issue)";
    fmStockOUT.Form.WhereColumn = "id";
    fmStockOUT.Form.AssignFields(JSON.stringify(jsonStockOUT));
    fmStockOUT.Form.FirstFocusControl = "ispno";
    fmStockOUT.Form.SearchColumns = "id";
    fmStockOUT.PrimaryColumn = "id";
    fmStockOUT.Form.ExternalValidationEnable = true;
    fmStockOUT.Form.ModalType = "XL";
    jsonTranStockOUT = [
        {editable:"Y",required:"Y",width:"120",cnm:"itid",lbl:"Item ID",ctp:"ACList",vtp:"S",maxlen:"",json:"",ajaxid:"",selidcol:"itid",selcol:"itid",showcol:"itid,mtcd,material,uom,avl,loc,sloc,ssloc,make,critical,omtcd,skid",whcol:"mtcd,omtcd,material",ACColWidth:"0:70,1:100,2:200,3:80,4:80,5:120,6:120,7:120,8:100,H:200,W:950"},
        {editable:"N",required:"N",width:"90",cnm:"mtcd",lbl:"UMC No",ctp:"TB",vtp:"S",maxlen:"",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",ACColWidth:""},
        {editable:"N",required:"N",width:"380",cnm:"material",lbl:"Material",ctp:"TB",vtp:"S",maxlen:"",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",ACColWidth:""},
        {editable:"N",required:"N",width:"120",cnm:"make",lbl:"Make",ctp:"TB",vtp:"S",maxlen:"",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",ACColWidth:""},
        {editable:"N",required:"N",width:"120",cnm:"loc",lbl:"Location",ctp:"TB",vtp:"S",maxlen:"",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",ACColWidth:""},
        {editable:"N",required:"N",width:"100",cnm:"sloc",lbl:"Sub Loc",ctp:"TB",vtp:"S",maxlen:"",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",ACColWidth:""},
        {editable:"N",required:"N",width:"80",cnm:"ssloc",lbl:"Rack",ctp:"TB",vtp:"S",maxlen:"",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",ACColWidth:""},
        {editable:"N",required:"N",width:"60",cnm:"pqty",lbl:"Stock",ctp:"TB",vtp:"S",maxlen:"",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",ACColWidth:""},
        {editable:"Y",required:"Y",width:"60",cnm:"qty",lbl:"Issue",ctp:"TB",vtp:"D",maxlen:"",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",ACColWidth:""},
        {editable:"N",required:"N",width:"60",cnm:"nqty",lbl:"Available",ctp:"TB",vtp:"S",maxlen:"",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:""},
        {editable:"N",required:"N",width:"100",cnm:"critical",lbl:"Critical",ctp:"TB",vtp:"S",maxlen:"",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",ACColWidth:""},
        {editable:"N",required:"N",width:"70",cnm:"uom",lbl:"UOM",ctp:"TB",vtp:"S",maxlen:"",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",ACColWidth:""},
        {editable:"N",required:"N",width:"80",cnm:"skid",lbl:"Stock ID",ctp:"TB",vtp:"S",maxlen:"",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",ACColWidth:""}
     ];

     fmStockOUT.TranGridJSON = jsonTranStockOUT;

     function fmStockOUT_ispno_DataSelected(json){
        fmStockOUT.Form.getControlKey("isto").setText(json.enm);
     }

     function fmStockOUT_tknspno_DataSelected(json){
        fmStockOUT.Form.getControlKey("tknby").setText(json.ctnm);  
     }

     function fmStockOUT_Open(cnt,msg)
     {
    
        fmStockOUT.TranGridView.GridView.SelectMode = "C";
        fmStockOUT.TranGridView.GridView.setGridViewHeight(350);
        fmStockOUT.TranGridView.GridView.setDefaultWidth(true);
        fmStockOUT.TranGridView.GridView.setScrollBarY(true);
        fmStockOUT.TranGridView.GridView.setScrollBarX(true);
        
        //fmStockOUT.Form.getControlKey("ispno").ComboBox = true;
        fmStockOUT.Form.getControlKey("tknspno").ComboBox = true;
            
            
        (new HC_DelayCall()).Call(function(){
            fmStockOUT.Form.getControlKey("loc").setText(GP.loc);
            fmStockOUT.Form.getControlKey("dt").setText(GP.sysdate);
            fmStockOUT.Form.getControlKey("cdt").setText(GP.sysdate);
            fmStockOUT.Form.getControlKey("cby").setText(GP.uid);
            fmStockOUT.Form.getControlKey("cnm").setText(GP.unm);
        });
        
        if(msg=="Open_Form_Modal_KEY_ReadOnly"){
            
            fmStockOUT.TranGridView.GridView.setSearching(); 
            fmStockOUT.TranGridView.GridView.enablePaging(6);
       
        }
        
     }
     
     function fmStockOUT_ExternalValidation()
     {
        return fmStockOUT.TranGridView.validateGridView();
     }

     function fmStockOUT_SaveFormEnd()
     {
        alert("Stock Issue Process Successfully Completed . . . Please check your stock"); 
        location.reload();
     }
     
     
     function fmStockOUT_inList(json,ri){
         var itid,mtcd,material,make,loc,sloc,ssloc;
         if(json.material!=""){
            for(var i=0;i<fmStockOUT.TranGridView.GridView.getRowLength();i++){
                if(i!=ri){
                itid = fmStockOUT.TranGridView.GridView.getHTML(i,0);
                mtcd = fmStockOUT.TranGridView.GridView.getHTML(i,1);
                material = fmStockOUT.TranGridView.GridView.getHTML(i,2);
                make = fmStockOUT.TranGridView.GridView.getHTML(i,3);
                loc = fmStockOUT.TranGridView.GridView.getHTML(i,4);
                sloc = fmStockOUT.TranGridView.GridView.getHTML(i,5);
                ssloc = fmStockOUT.TranGridView.GridView.getHTML(i,6);
                if(itid==json.itid && mtcd==json.mtcd && material==json.material && make==json.make && sloc==json.sloc && ssloc==json.ssloc)
                    return true;
                }
            }
         }
         return false;
     }
     
     function fmStockOUT_TranGridView_DataSelected(r,c,json){
         if(c==0){
             if(json!=null){
                if(!fmStockOUT_inList(json,r)){
                    if(json.material!=""){
                        fmStockOUT.TranGridView.GridView.setHTML(r,1,json.mtcd);
                        fmStockOUT.TranGridView.GridView.setHTML(r,2,json.material);
                        fmStockOUT.TranGridView.GridView.setHTML(r,3,json.make);
                        fmStockOUT.TranGridView.GridView.setHTML(r,4,json.loc);
                        fmStockOUT.TranGridView.GridView.setHTML(r,5,json.sloc);
                        fmStockOUT.TranGridView.GridView.setHTML(r,6,json.ssloc);
                        fmStockOUT.TranGridView.GridView.setHTML(r,7,json.avl);
                        fmStockOUT.TranGridView.GridView.setHTMLKey(r,"critical",json.critical);
                        fmStockOUT.TranGridView.GridView.setHTMLKey(r,"uom",json.uom);
                        fmStockOUT.TranGridView.GridView.setHTMLKey(r,"skid",json.skid);
                    }
                }
                else{
                    alert("Material Already Selected In List Please Choose Another Material");
                    (new HC_DelayCall()).Call(function(){
                        fmStockOUT.TranGridView.setFocusGridView(r,0);
                    });
                }
             }
         }
     }
     
     function fmStockOUT_TranGridView_MatrixLeave(r,c,ctl){
         
          if(c==0)
          {
             if(ctl.GridView.getJSON().length==0){
                 alert("Invalid Item Selected : ");
                 var vl = ctl.Text;
                 (new HC_DelayCall()).Call(function(){
                    fmStockOUT.TranGridView.GridView.setHTML(r,0,vl); 
                    fmStockOUT.TranGridView.setFocusGridView(r,0);
                 });
             }
         }
         
         if(c==8){
                var avl,iss;
                
                avl = eval(fmStockOUT.TranGridView.GridView.getHTML(r,7));
                iss = eval(fmStockOUT.TranGridView.GridView.getHTML(r,8));
                   
                if(iss<=0){
                    alert("Quantity cannot be 0 (Zero) or less : ");
                    (new HC_DelayCall()).Call(function(){
                        fmStockOUT.TranGridView.setFocusGridView(r,8);
                    });
                }
                else
                if(iss>avl){
                    alert("Cannot issue more than available quanity : " + avl);
                    (new HC_DelayCall()).Call(function(){
                        fmStockOUT.TranGridView.setFocusGridView(r,8);
                    });
                    
                }
                else{
                    fmStockOUT.TranGridView.GridView.setHTML(r,9,(avl-iss));
                }
             
         }
     }


     function fmStockOUT_TranGridView_MatrixEnter(r,c,ctl){
         
        if(c==0){
            
            var loc = fmStockOUT.Form.getControlKey("loc").Text;

            if(loc!="")
            {
                var vl = ctl.Text;
                var aj = new HC_Ajax("lstAvailableStock");
                aj.addFormData("loc",fmStockOUT.Form.getControlKey("loc").Text);
                aj.CallServer(function(data){
                    ctl.GridView.enablePaging(5);
                    ctl.GridView.populateUsingJSON_Blank(data);
                    ctl.setText(vl);
                    
                });
            }
        }
    }
     
     
}catch(e){alert(e);}


try{
                            
    var fmStockTransfer = new HC_TransactionForms("fmStockTransfer");
    jsonStockTransfer = [
        {cnm:"id",width:"80",lbl:"ID",placeholder:"",ctp:"TB",required:"N",vtp:"S",validERR:"",ro:"Y",maxlen:"",nextctl:"descp",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"R0",bscol:"6",group:"",tab:"",tabtitle:""},
        {cnm:"loc",width:"60",lbl:"Location",placeholder:"",ctp:"TB",required:"Y",vtp:"S",validERR:"",ro:"Y",maxlen:"",nextctl:"descp",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",ACColWidth:"",row:"R0",bscol:"6",group:"",tab:"",tabtitle:""},
        {cnm:"descp",width:"80",lbl:"Description",placeholder:"",ctp:"TB",required:"N",vtp:"S",validERR:"",ro:"N",maxlen:"",nextctl:"dt",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"",bscol:"",group:"",tab:"",tabtitle:"",ACColWidth:""},
        {cnm:"dt",width:"90",lbl:"Stock Date",placeholder:"",ctp:"TBDate",required:"Y",vtp:"S",validERR:"",ro:"N",maxlen:"",nextctl:"GridView",json:"",ajaxid:"",selidcol:"id",selcol:"",showcol:"",whcol:"",row:"R1",bscol:"3",group:"",tab:"",tabtitle:"",ACColWidth:""},
        {cnm:"cdt",width:"90",lbl:"Create Date",placeholder:"",ctp:"TB",required:"Y",vtp:"S",validERR:"",ro:"Y",maxlen:"",nextctl:"GridView",json:"",ajaxid:"",selidcol:"id",selcol:"",showcol:"",whcol:"",row:"R1",bscol:"3",group:"",tab:"",tabtitle:"",ACColWidth:""},
        {cnm:"cby",width:"60",lbl:"UID",placeholder:"",ctp:"TB",required:"Y",vtp:"S",validERR:"",ro:"Y",maxlen:"",nextctl:"GridView",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",ACColWidth:"",row:"R1",bscol:"3",group:"",tab:"",tabtitle:""},
        {cnm:"cnm",width:"60",lbl:"UserName",placeholder:"",ctp:"TB",required:"N",vtp:"S",validERR:"",ro:"Y",maxlen:"",nextctl:"GridView",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",ACColWidth:"",row:"R1",bscol:"3",group:"",tab:"",tabtitle:""}
   ];

    fmStockTransfer.Form.Heading = "Stock Transfer To Another Location";
    fmStockTransfer.Form.WhereColumn = "id";
    fmStockTransfer.Form.AssignFields(JSON.stringify(jsonStockTransfer));
    fmStockTransfer.Form.FirstFocusControl = "dt";
    fmStockTransfer.Form.SearchColumns = "id";
    fmStockTransfer.PrimaryColumn = "id";
    fmStockTransfer.Form.ExternalValidationEnable = true;
    fmStockTransfer.Form.ModalType = "XL";
    jsonTranStockTransfer = [
        {editable:"Y",required:"Y",width:"70",cnm:"itid",lbl:"Item ID",ctp:"ACList",vtp:"S",maxlen:"",json:"",ajaxid:"",selidcol:"itid",selcol:"itid",showcol:"itid,mtcd,material,loc,sloc,ssloc,make,avl,critical,uom,skid",whcol:"mtcd,material",ACColWidth:"0:70,1:100,2:200,3:120,4:120,5:90,6:90,7:80,8:100,H:200,W:950"},
        {editable:"N",required:"N",width:"90",cnm:"mtcd",lbl:"UMC No",ctp:"TB",vtp:"S",maxlen:"",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",ACColWidth:""},
        {editable:"N",required:"N",width:"380",cnm:"material",lbl:"Material",ctp:"TB",vtp:"S",maxlen:"",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",ACColWidth:""},
        {editable:"N",required:"N",width:"120",cnm:"make",lbl:"Make",ctp:"TB",vtp:"S",maxlen:"",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",ACColWidth:""},
        {editable:"N",required:"N",width:"120",cnm:"loc",lbl:"Location",ctp:"TB",vtp:"S",maxlen:"",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",ACColWidth:""},
        {editable:"N",required:"N",width:"100",cnm:"sloc",lbl:"Sub Loc",ctp:"TB",vtp:"S",maxlen:"",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",ACColWidth:""},
        {editable:"N",required:"N",width:"80",cnm:"ssloc",lbl:"Rack",ctp:"TB",vtp:"S",maxlen:"",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",ACColWidth:""},
        {editable:"N",required:"N",width:"50",cnm:"pqty",lbl:"Stock",ctp:"TB",vtp:"S",maxlen:"",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",ACColWidth:""},
        {editable:"Y",required:"Y",width:"50",cnm:"qty",lbl:"Issue",ctp:"TB",vtp:"D",maxlen:"",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",ACColWidth:""},
        {editable:"N",required:"N",width:"50",cnm:"nqty",lbl:"Available",ctp:"TB",vtp:"S",maxlen:"",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:""},
        {editable:"Y",required:"Y",width:"220",cnm:"toloc",lbl:"To Location",ctp:"ACList",vtp:"S",maxlen:"",json:"",ajaxid:"",selidcol:"loc",selcol:"loc",showcol:"loc",whcol:"loc",ACColWidth:"0:150,H:200,W:200"},
        {editable:"N",required:"N",width:"100",cnm:"critical",lbl:"Critical",ctp:"TB",vtp:"S",maxlen:"",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",ACColWidth:""},
        {editable:"N",required:"N",width:"60",cnm:"uom",lbl:"UOM",ctp:"TB",vtp:"S",maxlen:"",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",ACColWidth:""},
        {editable:"N",required:"N",width:"80",cnm:"skid",lbl:"Stock ID",ctp:"TB",vtp:"S",maxlen:"",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",ACColWidth:""}
     ];

     fmStockTransfer.TranGridJSON = jsonTranStockTransfer;

     function fmStockTransfer_ispno_DataSelected(json){
        fmStockTransfer.Form.getControlKey("isto").setText(json.enm);
     }

     function fmStockTransfer_tknspno_DataSelected(json){
        fmStockTransfer.Form.getControlKey("tknby").setText(json.ctnm);  
     }

     function fmStockTransfer_Open(cnt,msg)
     {
        
        fmStockTransfer.TranGridView.GridView.SelectMode = "C";
        fmStockTransfer.TranGridView.GridView.setGridViewHeight(350);
        
        fmStockTransfer.TranGridView.GridView.setDefaultWidth(true);
        fmStockTransfer.TranGridView.GridView.setScrollBarY(true);
        fmStockTransfer.TranGridView.GridView.setScrollBarX(true);
            
        (new HC_DelayCall()).Call(function(){
            fmStockTransfer.Form.getControlKey("loc").setText(GP.loc);
            fmStockTransfer.Form.getControlKey("cdt").setText(GP.sysdate);
            fmStockTransfer.Form.getControlKey("cby").setText(GP.uid);
            fmStockTransfer.Form.getControlKey("cnm").setText(GP.unm);
        });
        
        if(msg=="Open_Form_Modal_KEY_ReadOnly"){
            
            fmStockTransfer.TranGridView.GridView.setSearching(); 
            fmStockTransfer.TranGridView.GridView.enablePaging(6);
       
        }
        
     }
     
     function fmStockTransfer_ExternalValidation()
     {
        return fmStockTransfer.TranGridView.validateGridView();
     }

     function fmStockTransfer_SaveFormEnd()
     {
        alert("Stock Transfer Process Successfully Completed . . . Please check your stock"); 
        location.reload();
     }
     
     
     function fmStockTransfer_inList(json,ri){
         var itid,mtcd,material,make,loc,sloc,ssloc;
         if(json.itid!=""){
            for(var i=0;i<fmStockTransfer.TranGridView.GridView.getRowLength();i++){
                if(i!=ri){
                itid = fmStockTransfer.TranGridView.GridView.getHTML(i,0);
                mtcd = fmStockTransfer.TranGridView.GridView.getHTML(i,1);
                material = fmStockTransfer.TranGridView.GridView.getHTML(i,2);
                make = fmStockTransfer.TranGridView.GridView.getHTML(i,3);
                loc = fmStockTransfer.TranGridView.GridView.getHTML(i,4);
                sloc = fmStockTransfer.TranGridView.GridView.getHTML(i,5);
                ssloc = fmStockTransfer.TranGridView.GridView.getHTML(i,6);

                if(itid==json.itid && mtcd==json.mtcd && material==json.material && make==json.make && loc==json.loc && sloc==json.sloc && ssloc==json.ssloc)
                    return true;
                }
            }
         }
         return false;
     }
     
     function fmStockTransfer_TranGridView_DataSelected(r,c,json){
         if(c==0){
             if(json!=null){
                if(!fmStockTransfer_inList(json,r)){
                    if(json.material!=""){
                        fmStockTransfer.TranGridView.GridView.setHTML(r,1,json.mtcd);
                        fmStockTransfer.TranGridView.GridView.setHTML(r,2,json.material);
                        fmStockTransfer.TranGridView.GridView.setHTML(r,3,json.make);
                        fmStockTransfer.TranGridView.GridView.setHTML(r,4,json.loc);
                        fmStockTransfer.TranGridView.GridView.setHTML(r,5,json.sloc);
                        fmStockTransfer.TranGridView.GridView.setHTML(r,6,json.ssloc);
                        fmStockTransfer.TranGridView.GridView.setHTML(r,7,json.avl);
                        fmStockTransfer.TranGridView.GridView.setHTMLKey(r,"critical",json.critical);
                        fmStockTransfer.TranGridView.GridView.setHTMLKey(r,"uom",json.uom);
                        fmStockTransfer.TranGridView.GridView.setHTMLKey(r,"skid",json.skid);
                    }
                }
                else{
                    alert("Material Already Selected In List Please Choose Another Material");
                    (new HC_DelayCall()).Call(function(){
                        fmStockTransfer.TranGridView.setFocusGridView(r,0);
                    });
                }
             }
         }
     }
     
     function fmStockTransfer_TranGridView_MatrixLeave(r,c,ctl){
         
          if(c==0 || c==10)
          {
             if(ctl.GridView.getJSON().length==0){
                 alert("Invalid Item Selected : ");
                 var vl = ctl.Text;
                 (new HC_DelayCall()).Call(function(){
                    fmStockTransfer.TranGridView.GridView.setHTML(r,c,vl); 
                    fmStockTransfer.TranGridView.setFocusGridView(r,c);
                 });
             }
         }
         
         if(c==8){
                var avl,iss;
                
                avl = eval(fmStockTransfer.TranGridView.GridView.getHTML(r,7));
                iss = eval(fmStockTransfer.TranGridView.GridView.getHTML(r,8));
                
                if(iss<=0){
                    alert("Quantity cannot be 0 (Zero) or less : ");
                    (new HC_DelayCall()).Call(function(){
                        fmStockOUT.TranGridView.setFocusGridView(r,8);
                    });
                }
                else
                if(iss>avl){
                    alert("Cannot issue more than available quanity : " + avl);
                    (new HC_DelayCall()).Call(function(){
                        fmStockTransfer.TranGridView.setFocusGridView(r,8);
                    });
                    
                }
                else{
                    fmStockTransfer.TranGridView.GridView.setHTML(r,9,(avl-iss));
                }
             
         }
     }


     function fmStockTransfer_TranGridView_MatrixEnter(r,c,ctl){
         
        if(c==0){
            
            var loc = fmStockTransfer.Form.getControlKey("loc").Text;

            if(loc!="")
            {
                var vl = ctl.Text;
                var aj = new HC_Ajax("lstAvailableStock");
                aj.addFormData("loc",fmStockTransfer.Form.getControlKey("loc").Text);
                aj.CallServer(function(data){
                    ctl.GridView.enablePaging(5);
                    ctl.GridView.populateUsingJSON_Blank(data);
                    ctl.setText(vl);
                    
                });
            }
        }
        
        if(c==10){
            var vl = ctl.Text;
            var aj = new HC_Ajax("lstTranLocation");
            aj.addFormData("loc",fmStockTransfer.Form.getControlKey("loc").Text);
            aj.CallServer(function(data){
                //alert(data);
                ctl.GridView.populateUsingJSON_Blank(data);
                 ctl.setText(vl);
            });
            
        }
    }
     
     
}catch(e){alert(e);}




try{
                            
    var fmStockINTransfer = new HC_TransactionForms("fmStockINTransfer");
    jsonStockINTransfer = [
        {cnm:"id",width:"80",lbl:"ID",placeholder:"",ctp:"TB",required:"N",vtp:"S",validERR:"",ro:"Y",maxlen:"",nextctl:"descp",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"R0",bscol:"6",group:"",tab:"",tabtitle:""},
        {cnm:"loc",width:"60",lbl:"Location",placeholder:"",ctp:"TB",required:"Y",vtp:"S",validERR:"",ro:"Y",maxlen:"",nextctl:"descp",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",ACColWidth:"",row:"R0",bscol:"6",group:"",tab:"",tabtitle:""},
        {cnm:"descp",width:"80",lbl:"Description",placeholder:"",ctp:"TB",required:"N",vtp:"S",validERR:"",ro:"N",maxlen:"",nextctl:"dt",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"",bscol:"",group:"",tab:"",tabtitle:"",ACColWidth:""},
        {cnm:"dt",width:"100",lbl:"Stock Date",placeholder:"",ctp:"TBDate",required:"Y",vtp:"S",validERR:"",ro:"N",maxlen:"",nextctl:"GridView",json:"",ajaxid:"",selidcol:"id",selcol:"",showcol:"",whcol:"",row:"R1",bscol:"3",group:"",tab:"",tabtitle:"",ACColWidth:""},
        {cnm:"cdt",width:"100",lbl:"Date",placeholder:"",ctp:"TB",required:"Y",vtp:"S",validERR:"",ro:"Y",maxlen:"",nextctl:"GridView",json:"",ajaxid:"",selidcol:"id",selcol:"",showcol:"",whcol:"",row:"R1",bscol:"3",group:"",tab:"",tabtitle:"",ACColWidth:""},
        {cnm:"cby",width:"60",lbl:"UID",placeholder:"",ctp:"TB",required:"Y",vtp:"S",validERR:"",ro:"Y",maxlen:"",nextctl:"GridView",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",ACColWidth:"",row:"R1",bscol:"3",group:"",tab:"",tabtitle:""},
        {cnm:"cnm",width:"60",lbl:"UserName",placeholder:"",ctp:"TB",required:"N",vtp:"S",validERR:"",ro:"Y",maxlen:"",nextctl:"GridView",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",ACColWidth:"",row:"R1",bscol:"3",group:"",tab:"",tabtitle:""}
   ];

    fmStockINTransfer.Form.Heading = "Internal Goods Movement at Same Location";
    fmStockINTransfer.Form.WhereColumn = "id";
    fmStockINTransfer.Form.AssignFields(JSON.stringify(jsonStockINTransfer));
    fmStockINTransfer.Form.FirstFocusControl = "dt";
    fmStockINTransfer.Form.SearchColumns = "id";
    fmStockINTransfer.PrimaryColumn = "id";
    fmStockINTransfer.Form.ExternalValidationEnable = true;
    fmStockINTransfer.Form.ModalType = "XL";
    jsonTranStockINTransfer = [
        {editable:"Y",required:"Y",width:"70",cnm:"itid",lbl:"Item ID",ctp:"ACList",vtp:"S",maxlen:"",json:"",ajaxid:"",selidcol:"itid",selcol:"itid",showcol:"itid,mtcd,material,loc,sloc,ssloc,make,avl,critical,uom,skid",whcol:"mtcd,material",ACColWidth:"0:70,1:100,2:200,3:120,4:120,5:90,6:90,7:80,H:200,W:950"},
        {editable:"N",required:"N",width:"90",cnm:"mtcd",lbl:"UMC No",ctp:"TB",vtp:"S",maxlen:"",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",ACColWidth:""},
        {editable:"N",required:"N",width:"380",cnm:"material",lbl:"Material",ctp:"TB",vtp:"S",maxlen:"",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",ACColWidth:""},
        {editable:"N",required:"N",width:"120",cnm:"make",lbl:"Make",ctp:"TB",vtp:"S",maxlen:"",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",ACColWidth:""},
        {editable:"N",required:"N",width:"120",cnm:"loc",lbl:"Location",ctp:"TB",vtp:"S",maxlen:"",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",ACColWidth:""},
        {editable:"N",required:"N",width:"100",cnm:"sloc",lbl:"Sub Loc",ctp:"TB",vtp:"S",maxlen:"",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",ACColWidth:""},
        {editable:"N",required:"N",width:"80",cnm:"ssloc",lbl:"Rack",ctp:"TB",vtp:"S",maxlen:"",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",ACColWidth:""},
        {editable:"N",required:"N",width:"50",cnm:"pqty",lbl:"Stock",ctp:"TB",vtp:"S",maxlen:"",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",ACColWidth:""},
        {editable:"Y",required:"Y",width:"50",cnm:"qty",lbl:"Issue",ctp:"TB",vtp:"D",maxlen:"",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",ACColWidth:""},
        {editable:"N",required:"N",width:"50",cnm:"nqty",lbl:"Available",ctp:"TB",vtp:"S",maxlen:"",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:""},
        {editable:"N",required:"Y",width:"550",cnm:"tosloc",lbl:"To Sub Location",ctp:"ACList",vtp:"S",maxlen:"",json:"",ajaxid:"",selidcol:"loc",selcol:"loc",showcol:"loc",whcol:"loc",ACColWidth:"0:150,H:200,W:200"},
        {editable:"N",required:"N",width:"50",cnm:"critical",lbl:"Critical",ctp:"TB",vtp:"S",maxlen:"",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:""},
        {editable:"N",required:"N",width:"50",cnm:"uom",lbl:"UOM",ctp:"TB",vtp:"S",maxlen:"",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:""},
        {editable:"N",required:"N",width:"70",cnm:"skid",lbl:"Stock ID",ctp:"TB",vtp:"S",maxlen:"",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:""}
     ];

     fmStockINTransfer.TranGridJSON = jsonTranStockINTransfer;

     function fmStockINTransfer_ispno_DataSelected(json){
        fmStockINTransfer.Form.getControlKey("isto").setText(json.enm);
     }

     function fmStockINTransfer_tknspno_DataSelected(json){
        fmStockINTransfer.Form.getControlKey("tknby").setText(json.ctnm);  
     }

     function fmStockINTransfer_Open(cnt,msg)
     {
        
        fmStockINTransfer.TranGridView.GridView.SelectMode = "C";
        
        fmStockINTransfer.TranGridView.GridView.setGridViewHeight(350);
        
        fmStockINTransfer.TranGridView.GridView.setDefaultWidth(true);
        fmStockINTransfer.TranGridView.GridView.setScrollBarY(true);
        fmStockINTransfer.TranGridView.GridView.setScrollBarX(true);
            
        (new HC_DelayCall()).Call(function(){
            fmStockINTransfer.Form.getControlKey("loc").setText(GP.loc);
            fmStockINTransfer.Form.getControlKey("dt").setText(GP.sysdate);
            fmStockINTransfer.Form.getControlKey("cdt").setText(GP.sysdate);
            fmStockINTransfer.Form.getControlKey("cby").setText(GP.uid);
            fmStockINTransfer.Form.getControlKey("cnm").setText(GP.unm);
        });
        
        if(msg=="Open_Form_Modal_KEY_ReadOnly"){
            
            fmStockINTransfer.TranGridView.GridView.setSearching(); 
            fmStockINTransfer.TranGridView.GridView.enablePaging(6);
       
        }
        
     }
     
     function fmStockINTransfer_ExternalValidation()
     {
        return fmStockINTransfer.TranGridView.validateGridView();
     }

     function fmStockINTransfer_SaveFormEnd()
     {
        alert("Internal Goods Movement Process Successfully Completed . . . Please check your stock"); 
        location.reload();
     }
     
     
     function fmStockINTransfer_inList(json,ri){
         var itid,mtcd,material,make,loc,sloc,ssloc;
         if(json.material!=""){
            for(var i=0;i<fmStockINTransfer.TranGridView.GridView.getRowLength();i++){
                if(i!=ri){
                itid = fmStockINTransfer.TranGridView.GridView.getHTML(i,0);
                mtcd = fmStockINTransfer.TranGridView.GridView.getHTML(i,1);
                material = fmStockINTransfer.TranGridView.GridView.getHTML(i,2);
                make = fmStockINTransfer.TranGridView.GridView.getHTML(i,3);
                loc = fmStockINTransfer.TranGridView.GridView.getHTML(i,4);
                sloc = fmStockINTransfer.TranGridView.GridView.getHTML(i,5);
                ssloc = fmStockINTransfer.TranGridView.GridView.getHTML(i,6);

                if(itid==json.itid && mtcd==json.mtcd && material==json.material && make==json.make && loc==json.loc && sloc==json.sloc && ssloc==json.ssloc)
                    return true;
                }
            }
         }
         return false;
     }
     
     function fmStockINTransfer_TranGridView_DataSelected(r,c,json){
         if(c==0){
             if(json!=null){
                if(!fmStockINTransfer_inList(json,r)){
                    if(json.material!=""){
                        fmStockINTransfer.TranGridView.GridView.setHTML(r,1,json.mtcd);
                        fmStockINTransfer.TranGridView.GridView.setHTML(r,2,json.material);
                        fmStockINTransfer.TranGridView.GridView.setHTML(r,3,json.make);
                        fmStockINTransfer.TranGridView.GridView.setHTML(r,4,json.loc);
                        fmStockINTransfer.TranGridView.GridView.setHTML(r,5,json.sloc);
                        fmStockINTransfer.TranGridView.GridView.setHTML(r,6,json.ssloc);
                        fmStockINTransfer.TranGridView.GridView.setHTML(r,7,json.avl);
                        fmStockINTransfer.TranGridView.GridView.setHTML(r,11,json.critical);
                        fmStockINTransfer.TranGridView.GridView.setHTML(r,12,json.uom);
                        fmStockINTransfer.TranGridView.GridView.setHTML(r,13,json.skid);
                    }
                }
                else{
                    alert("Material Already Selected In List Please Choose Another Material");
                    (new HC_DelayCall()).Call(function(){
                        fmStockINTransfer.TranGridView.setFocusGridView(r,0);
                    });
                }
             }
         }
     }
     
     function fmStockINTransfer_TranGridView_MatrixLeave(r,c,ctl){
         
          if(c==0 || c==10)
          {
             if(ctl.GridView.getJSON().length==0){
                 alert("Invalid Item Selected : ");
                 var vl = ctl.Text;
                 (new HC_DelayCall()).Call(function(){
                    fmStockINTransfer.TranGridView.GridView.setHTML(r,c,vl); 
                    fmStockINTransfer.TranGridView.setFocusGridView(r,c);
                 });
             }
         }
         
         if(c==8){
                var avl,iss;
                
                avl = eval(fmStockINTransfer.TranGridView.GridView.getHTML(r,7));
                iss = fmStockINTransfer.TranGridView.GridView.getHTML(r,8);
                
                var vld = new HC_Validation();
                
                if(!(new HC_Validation).getValidationStatus(iss,"D"))
                {
                    alert("Quantity : " + vld.getValidationMessage("D"));
                    (new HC_DelayCall()).Call(function(){
                        fmStockINTransfer.TranGridView.setFocusGridView(r,8);
                    });
                }
                else
                if(eval(iss)<=0){
                    alert("Quantity cannot be 0 (Zero) or less : ");
                    (new HC_DelayCall()).Call(function(){
                        fmStockINTransfer.TranGridView.setFocusGridView(r,8);
                    });
                }
                else
                if(eval(iss)>avl){
                    alert("Cannot issue more than available quanity : " + avl);
                    (new HC_DelayCall()).Call(function(){
                        fmStockINTransfer.TranGridView.setFocusGridView(r,8);
                    });
                    
                }
                else{
                    fmStockINTransfer.TranGridView.GridView.setHTML(r,9,(avl-iss));
                    
                    fmSubLocTransfer.Form.FormOnly = true;
                    fmSubLocTransfer.OpenFormFinal(fmStockINTransfer.Container,"FOMO");
                    fmSubLocTransfer.Form.getControlKey("idx").setText(r);
                    
                    fmSubLocTransfer.Form.getControlKey("itid").setText(fmStockINTransfer.TranGridView.GridView.getHTML(r,0));
                    fmSubLocTransfer.Form.getControlKey("umc").setText(fmStockINTransfer.TranGridView.GridView.getHTML(r,1));
                    fmSubLocTransfer.Form.getControlKey("material").setText(fmStockINTransfer.TranGridView.GridView.getHTML(r,2));
                    fmSubLocTransfer.Form.getControlKey("qty").setText(fmStockINTransfer.TranGridView.GridView.getHTML(r,8));

                    fmSubLocTransfer.Form.getControlKey("loc").setText(fmStockINTransfer.TranGridView.GridView.getHTML(r,4));
                    fmSubLocTransfer.Form.getControlKey("sloc").setText(fmStockINTransfer.TranGridView.GridView.getHTML(r,5));
                    fmSubLocTransfer.Form.getControlKey("ssloc").setText(fmStockINTransfer.TranGridView.GridView.getHTML(r,6));

                    fmSubLocTransfer.TranGridView.GridView.setGridViewHeight(250);
                    
                    
                    var sbl = fmStockINTransfer.TranGridView.GridView.getHTML(r,10);
                    
                    if(sbl!="")
                    {
                        var ar = sbl.split(',');
                        var ard = ar[0].split(':');
                        
                        for (var j=0;j<ard.length;j++)
                        {
                            fmSubLocTransfer.TranGridView.GridView.setHTML(0,j,ard[j]);
                        }
                        
                        for(var i=1;i<ar.length;i++){
                            fmSubLocTransfer.TranGridView.GridView.addRowHTML();
                            var ard = ar[i].split(':');
                            for (var j=0;j<ard.length;j++)
                            {
                                fmSubLocTransfer.TranGridView.GridView.setHTML(i,j,ard[j]);
                            }
                        }
                    }
                    
                }
         }
     }


     function fmStockINTransfer_TranGridView_MatrixEnter(r,c,ctl){
         
        if(c==0){
            
            var loc = fmStockINTransfer.Form.getControlKey("loc").Text;

            if(loc!="")
            {
                var vl = ctl.Text;
                var aj = new HC_Ajax("lstAvailableStock");
                aj.addFormData("loc",fmStockINTransfer.Form.getControlKey("loc").Text);
                aj.CallServer(function(data){
                    ctl.GridView.enablePaging(5);
                    ctl.GridView.populateUsingJSON_Blank(data);
                    ctl.setText(vl);
                    
                });
            }
        }
        
        if(c==10){
            
            var aj = new HC_Ajax("lstTranLocation");
            aj.addFormData("loc",fmStockINTransfer.Form.getControlKey("loc").Text);
            aj.CallServer(function(data){
                //alert(data);
                ctl.GridView.populateUsingJSON_Blank(data);
            });
            
        }
    }
     
     
}catch(e){alert(e);}



try{
                            
    var fmSubLocTransfer = new HC_TransactionForms("fmSubLocTransfer");
    jsonSubLocTransfer = [
        {cnm:"itid",width:"80",lbl:"Item ID",placeholder:"",ctp:"TB",required:"N",vtp:"S",validERR:"",ro:"Y",maxlen:"",nextctl:"descp",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"R0",bscol:"6",group:"",tab:"",tabtitle:""},
        {cnm:"umc",width:"180",lbl:"UMC",placeholder:"",ctp:"TB",required:"N",vtp:"S",validERR:"",ro:"Y",maxlen:"",nextctl:"descp",json:"",ajaxid:"",selidcol:"id",selcol:"",showcol:"",whcol:"",row:"R0",bscol:"6",group:"",tab:"",tabtitle:"",ACColWidth:""},
        {cnm:"material",width:"60",lbl:"Material",placeholder:"",ctp:"TB",required:"N",vtp:"S",validERR:"",ro:"Y",maxlen:"",nextctl:"",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",ACColWidth:"",row:"R1",bscol:"6",group:"",tab:"",tabtitle:""},
        {cnm:"qty",width:"80",lbl:"Qty",placeholder:"",ctp:"TB",required:"N",vtp:"S",validERR:"",ro:"Y",maxlen:"",nextctl:"GridView",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"R1",bscol:"3",group:"",tab:"",tabtitle:"",ACColWidth:""},
        {cnm:"idx",width:"80",lbl:"Idx",placeholder:"",ctp:"TB",required:"N",vtp:"S",validERR:"",ro:"Y",maxlen:"",nextctl:"GridView",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"R1",bscol:"3",group:"",tab:"",tabtitle:"",ACColWidth:""},
        {cnm:"loc",width:"80",lbl:"Location",placeholder:"",ctp:"TB",required:"N",vtp:"S",validERR:"",ro:"Y",maxlen:"",nextctl:"GridView",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"R2",bscol:"4",group:"",tab:"",tabtitle:"",ACColWidth:""},
        {cnm:"sloc",width:"80",lbl:"Sub Loc",placeholder:"",ctp:"TB",required:"N",vtp:"S",validERR:"",ro:"Y",maxlen:"",nextctl:"GridView",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"R2",bscol:"4",group:"",tab:"",tabtitle:"",ACColWidth:""},
        {cnm:"ssloc",width:"80",lbl:"Rack",placeholder:"",ctp:"TB",required:"N",vtp:"S",validERR:"",ro:"Y",maxlen:"",nextctl:"GridView",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"R2",bscol:"4",group:"",tab:"",tabtitle:"",ACColWidth:""}
   ];
    
    fmSubLocTransfer.Form.Heading = "Stock Location Assign";
    fmSubLocTransfer.Form.WhereColumn = "id";
    fmSubLocTransfer.Form.AssignFields(JSON.stringify(jsonSubLocTransfer));
    fmSubLocTransfer.Form.FirstFocusControl = "loc";
    fmSubLocTransfer.Form.SearchColumns = "itid";
    fmSubLocTransfer.PrimaryColumn = "itid";
    fmSubLocTransfer.Form.ModalType = "L";
    fmSubLocTransfer.Form.ExternalValidationEnable = true;
    
    jsonTranSubLocTransfer = [
        {editable:"Y",required:"Y",width:"150",cnm:"sloc",lbl:"Sub Loc",ctp:"ACList",vtp:"S",maxlen:"",json:"",ajaxid:"",selidcol:"sloc",selcol:"sloc",showcol:"sloc",whcol:"sloc",ACColWidth:"0:250,H:100,W:300"},
        {editable:"Y",required:"N",width:"130",cnm:"ssloc",lbl:"Rack",ctp:"ACList",vtp:"S",maxlen:"",json:"",ajaxid:"",selidcol:"ssloc",selcol:"ssloc",showcol:"ssloc",whcol:"ssloc",ACColWidth:"0:250,H:100,W:300"},
        {editable:"Y",required:"Y",width:"70",cnm:"qty",lbl:"Qty",ctp:"TB",vtp:"ND",maxlen:"",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:""}
     ];

     fmSubLocTransfer.TranGridJSON = jsonTranSubLocTransfer;

     function fmSubLocTransfer_Open()
     {
        var r = fmSubLocTransfer.Form.getControlKey("idx").Text;
        (new HC_DelayCall()).Call(function(){
            
            //fmSubLocTransfer.ButtonGrFormTran.Buttons[2].hide();
            
            
            
            HCGlobal = fmSubLocTransfer;
            
            fmSubLocTransfer.TranGridView.setFocus();
        });
     }
     
     function fmSubLocTransfer_ExternalValidation()
     {
        var qt = 0; 
        if(fmSubLocTransfer.TranGridView.validateGridView()){
            
            for(var i=0;i<fmSubLocTransfer.TranGridView.GridView.getRowLength();i++){
                if(fmSubLocTransfer.TranGridView.GridView.getHTML(i,2)!="")
                qt += eval(fmSubLocTransfer.TranGridView.GridView.getHTML(i,2));
            }
            if(eval(fmSubLocTransfer.Form.getControlKey("qty").Text)!=qt)
            {
                fmSubLocTransfer.TranGridView.setFocus();
                alert("Please Check Assign Qty");
            }
            else{
                rs = "";
                for(var i=0;i<fmSubLocTransfer.TranGridView.GridView.getRowLength();i++){
                    if(fmSubLocTransfer.TranGridView.GridView.getHTML(i,2)!=""){
                        rs += "," + fmSubLocTransfer.TranGridView.GridView.getHTML(i,0);
                        rs += ":" + fmSubLocTransfer.TranGridView.GridView.getHTML(i,1);
                        rs += ":" + fmSubLocTransfer.TranGridView.GridView.getHTML(i,2);
                    }
                }
                
                var idx = fmSubLocTransfer.Form.getControlKey("idx").Text;
                fmStockINTransfer.TranGridView.GridView.setHTML(idx,10,rs.substring(1));
                fmSubLocTransfer.Form.Modal.CloseModal();
                fmStockINTransfer.TranGridView.ActiveCol=-1;
                fmStockINTransfer.TranGridView.ActiveRow=-1;
                fmStockINTransfer.TranGridView.setFocusGridView((idx+1),0);
                //alert(rs.substring(1));
                
                HCGlobal = fmStockINTransfer;
            }
        } 
        
     }
     
     function fmSubLocTransfer_inList(json){
         var itid,mtcd,material,make,loc;
         for(var i=0;i<fmStockINTransfer.TranGridView.GridView.getRowLength();i++){
             itid = fmStockINTransfer.TranGridView.GridView.getHTML(i,0);
             mtcd = fmStockINTransfer.TranGridView.GridView.getHTML(i,1);
             material = fmStockINTransfer.TranGridView.GridView.getHTML(i,2);
             make = fmStockINTransfer.TranGridView.GridView.getHTML(i,3);
             loc = fmStockINTransfer.TranGridView.GridView.getHTML(i,4);
             
             if(itid==json.itid && mtcd==json.mtcd && material==json.material && make==json.make && loc==json.loc)
                 return true;
         }
         return false;
     }
     
     function fmSubLocTransfer_TranGridView_DataSelected(r,c,json){
         
     }
     
     function fmSubLocTransfer_TranGridView_MatrixLeave(r,c,ctl){
     }
     

     function fmSubLocTransfer_TranGridView_MatrixEnter(r,c,ctl){
         if(c==0){
            
            var vl = ctl.Text;
            ctl.ComboBox = true;
            
            var aj = new HC_Ajax("lstSubLoc");
            aj.addFormData("loc",GP.loc,GP.loc);
            //aj.addFormData("sloc",fmSubLocTransfer.Form.getControlKey("sloc").Text);
            aj.CallServer(function(data){
                ctl.GridView.populateUsingJSON(data);
                ctl.setText(vl);
            });
         }
         
         if(c==1){
            var vl = ctl.Text;
            ctl.ComboBox = true;
            var aj = new HC_Ajax("lstSubSubLoc");
            aj.addFormData("loc",GP.loc,GP.loc);
            aj.CallServer(function(data){
                ctl.GridView.populateUsingJSON(data);
                ctl.setText(vl);
            });
         }
         
     }
     
}catch(e){alert(e);}




try{
                            
    var fmStockSCRAP = new HC_TransactionForms("fmStockSCRAP");
    jsonStockSCRAP = [
        {cnm:"id",width:"80",lbl:"ID",placeholder:"",ctp:"TB",required:"N",vtp:"S",validERR:"",ro:"Y",maxlen:"",nextctl:"descp",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"R0",bscol:"6",group:"",tab:"",tabtitle:""},
        {cnm:"loc",width:"60",lbl:"Location",placeholder:"",ctp:"TB",required:"Y",vtp:"S",validERR:"",ro:"Y",maxlen:"",nextctl:"descp",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",ACColWidth:"",row:"R0",bscol:"6",group:"",tab:"",tabtitle:""},
        {cnm:"descp",width:"80",lbl:"Description",placeholder:"",ctp:"TB",required:"N",vtp:"S",validERR:"",ro:"N",maxlen:"",nextctl:"dt",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"",bscol:"",group:"",tab:"",tabtitle:"",ACColWidth:""},
        {cnm:"dt",width:"120",lbl:"Stock Date",placeholder:"",ctp:"TBDate",required:"Y",vtp:"S",validERR:"",ro:"N",maxlen:"",nextctl:"GridView",json:"",ajaxid:"",selidcol:"id",selcol:"",showcol:"",whcol:"",row:"R1",bscol:"3",group:"",tab:"",tabtitle:"",ACColWidth:""},
        {cnm:"cdt",width:"120",lbl:"Create Date",placeholder:"",ctp:"TB",required:"Y",vtp:"S",validERR:"",ro:"Y",maxlen:"",nextctl:"GridView",json:"",ajaxid:"",selidcol:"id",selcol:"",showcol:"",whcol:"",row:"R1",bscol:"3",group:"",tab:"",tabtitle:"",ACColWidth:""},
        {cnm:"cby",width:"60",lbl:"UID",placeholder:"",ctp:"TB",required:"Y",vtp:"S",validERR:"",ro:"Y",maxlen:"",nextctl:"GridView",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",ACColWidth:"",row:"R1",bscol:"3",group:"",tab:"",tabtitle:""},
        {cnm:"cnm",width:"60",lbl:"UserName",placeholder:"",ctp:"TB",required:"N",vtp:"S",validERR:"",ro:"Y",maxlen:"",nextctl:"GridView",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",ACColWidth:"",row:"R1",bscol:"3",group:"",tab:"",tabtitle:""}
   ];

    fmStockSCRAP.Form.Heading = "Stock Scarapping Process";
    fmStockSCRAP.Form.WhereColumn = "id";
    fmStockSCRAP.Form.AssignFields(JSON.stringify(jsonStockSCRAP));
    fmStockSCRAP.Form.FirstFocusControl = "dt";
    fmStockSCRAP.Form.SearchColumns = "id";
    fmStockSCRAP.PrimaryColumn = "id";
    fmStockSCRAP.Form.ExternalValidationEnable = true;
    fmStockSCRAP.Form.ModalType = "XL";
    jsonTranStockSCRAP = [
        {editable:"Y",required:"Y",width:"70",cnm:"itid",lbl:"Item ID",ctp:"ACList",vtp:"S",maxlen:"",json:"",ajaxid:"",selidcol:"itid",selcol:"itid",showcol:"itid,mtcd,material,loc,sloc,ssloc,make,avl,critical,uom,skid",whcol:"mtcd,material",ACColWidth:"0:70,1:100,2:200,3:120,4:120,5:90,6:90,7:80,H:200,W:950"},
        {editable:"N",required:"N",width:"90",cnm:"mtcd",lbl:"UMC No",ctp:"TB",vtp:"S",maxlen:"",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",ACColWidth:""},
        {editable:"N",required:"N",width:"380",cnm:"material",lbl:"Material",ctp:"TB",vtp:"S",maxlen:"",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",ACColWidth:""},
        {editable:"N",required:"N",width:"120",cnm:"make",lbl:"Make",ctp:"TB",vtp:"S",maxlen:"",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",ACColWidth:""},
        {editable:"N",required:"N",width:"120",cnm:"loc",lbl:"Location",ctp:"TB",vtp:"S",maxlen:"",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",ACColWidth:""},
        {editable:"N",required:"N",width:"100",cnm:"sloc",lbl:"Sub Loc",ctp:"TB",vtp:"S",maxlen:"",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",ACColWidth:""},
        {editable:"N",required:"N",width:"80",cnm:"ssloc",lbl:"Rack",ctp:"TB",vtp:"S",maxlen:"",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",ACColWidth:""},
        {editable:"N",required:"N",width:"50",cnm:"pqty",lbl:"Stock",ctp:"TB",vtp:"S",maxlen:"",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",ACColWidth:""},
        {editable:"Y",required:"Y",width:"50",cnm:"qty",lbl:"Scrap",ctp:"TB",vtp:"D",maxlen:"",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",ACColWidth:""},
        {editable:"N",required:"N",width:"50",cnm:"nqty",lbl:"Available",ctp:"TB",vtp:"S",maxlen:"",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:""},
        {editable:"N",required:"N",width:"80",cnm:"critical",lbl:"Critical",ctp:"TB",vtp:"S",maxlen:"",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",ACColWidth:""},
        {editable:"N",required:"N",width:"50",cnm:"uom",lbl:"UOM",ctp:"TB",vtp:"S",maxlen:"",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",ACColWidth:""},
        {editable:"N",required:"N",width:"70",cnm:"skid",lbl:"Stock ID",ctp:"TB",vtp:"S",maxlen:"",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",ACColWidth:""}
     ];

     fmStockSCRAP.TranGridJSON = jsonTranStockSCRAP;

     function fmStockSCRAP_ispno_DataSelected(json){
        fmStockSCRAP.Form.getControlKey("isto").setText(json.enm);
     }

     function fmStockSCRAP_tknspno_DataSelected(json){
        fmStockSCRAP.Form.getControlKey("tknby").setText(json.ctnm);  
     }

     function fmStockSCRAP_Open(cnt,msg)
     {
        
        fmStockSCRAP.TranGridView.GridView.SelectMode = "C";
        
        fmStockSCRAP.TranGridView.GridView.setGridViewHeight(350);
        
        fmStockSCRAP.TranGridView.GridView.setDefaultWidth(true);
        fmStockSCRAP.TranGridView.GridView.setScrollBarY(true);
        fmStockSCRAP.TranGridView.GridView.setScrollBarX(true);
            
        (new HC_DelayCall()).Call(function(){
            fmStockSCRAP.Form.getControlKey("loc").setText(GP.loc);
            fmStockSCRAP.Form.getControlKey("dt").setText(GP.sysdate);
            fmStockSCRAP.Form.getControlKey("cdt").setText(GP.sysdate);
            fmStockSCRAP.Form.getControlKey("cby").setText(GP.uid);
            fmStockSCRAP.Form.getControlKey("cnm").setText(GP.unm);
        });
        
        if(msg=="Open_Form_Modal_KEY_ReadOnly"){
            
            fmStockSCRAP.TranGridView.GridView.setSearching(); 
            fmStockSCRAP.TranGridView.GridView.enablePaging(6);
       
        }
        
     }
     
     function fmStockSCRAP_ExternalValidation()
     {
        return fmStockSCRAP.TranGridView.validateGridView();
     }

     function fmStockSCRAP_SaveFormEnd()
     {
        alert("Stock Scarapping Process Successfully Completed . . . Please check your stock"); 
        location.reload();
     }
     
     
     function fmStockSCRAP_inList(json,ri){
         var itid,mtcd,material,make,loc,sloc,ssloc;
         if(json.material!=""){
            for(var i=0;i<fmStockSCRAP.TranGridView.GridView.getRowLength();i++){
                if(i!=ri){
                itid = fmStockSCRAP.TranGridView.GridView.getHTML(i,0);
                mtcd = fmStockSCRAP.TranGridView.GridView.getHTML(i,1);
                material = fmStockSCRAP.TranGridView.GridView.getHTML(i,2);
                make = fmStockSCRAP.TranGridView.GridView.getHTML(i,3);
                loc = fmStockSCRAP.TranGridView.GridView.getHTML(i,4);
                sloc = fmStockSCRAP.TranGridView.GridView.getHTML(i,5);
                ssloc = fmStockSCRAP.TranGridView.GridView.getHTML(i,6);

                if(itid==json.itid && mtcd==json.mtcd && material==json.material && make==json.make && loc==json.loc && sloc==json.sloc && ssloc==json.ssloc)
                    return true;
                }
            }
         }
         return false;
     }
     
     function fmStockSCRAP_TranGridView_DataSelected(r,c,json){
         if(c==0){
             if(json!=null){
                if(!fmStockSCRAP_inList(json,r)){
                    if(json.material!=""){
                        fmStockSCRAP.TranGridView.GridView.setHTML(r,1,json.mtcd);
                        fmStockSCRAP.TranGridView.GridView.setHTML(r,2,json.material);
                        fmStockSCRAP.TranGridView.GridView.setHTML(r,3,json.make);
                        fmStockSCRAP.TranGridView.GridView.setHTML(r,4,json.loc);
                        fmStockSCRAP.TranGridView.GridView.setHTML(r,5,json.sloc);
                        fmStockSCRAP.TranGridView.GridView.setHTML(r,6,json.ssloc);
                        fmStockSCRAP.TranGridView.GridView.setHTML(r,7,json.avl);
                        fmStockSCRAP.TranGridView.GridView.setHTML(r,10,json.critical);
                        fmStockSCRAP.TranGridView.GridView.setHTML(r,11,json.uom);
                        fmStockSCRAP.TranGridView.GridView.setHTML(r,12,json.skid);
                    }
                }
                else{
                    alert("Material Already Selected In List Please Choose Another Material");
                    (new HC_DelayCall()).Call(function(){
                        fmStockSCRAP.TranGridView.setFocusGridView(r,0);
                    });
                }
             }
         }
     }
     
     function fmStockSCRAP_TranGridView_MatrixLeave(r,c,ctl){
         
          if(c==0 || c==10)
          {
             if(ctl.GridView.getJSON().length==0){
                 alert("Invalid Item Selected : ");
                 var vl = ctl.Text;
                 (new HC_DelayCall()).Call(function(){
                    fmStockSCRAP.TranGridView.GridView.setHTML(r,c,vl); 
                    fmStockSCRAP.TranGridView.setFocusGridView(r,c);
                 });
             }
         }
         
         if(c==8){
                var avl,iss;
                
                avl = eval(fmStockSCRAP.TranGridView.GridView.getHTML(r,7));
                iss = eval(fmStockSCRAP.TranGridView.GridView.getHTML(r,8));
                
                if(iss<=0){
                    alert("Quantity cannot be 0 (Zero) or less : ");
                    (new HC_DelayCall()).Call(function(){
                        fmStockOUT.TranGridView.setFocusGridView(r,8);
                    });
                }
                else
                if(iss>avl){
                    alert("Cannot issue more than available quanity : " + avl);
                    (new HC_DelayCall()).Call(function(){
                        fmStockSCRAP.TranGridView.setFocusGridView(r,8);
                    });
                    
                }
                else{
                    fmStockSCRAP.TranGridView.GridView.setHTML(r,9,(avl-iss));
                }
         }
     }

     function fmStockSCRAP_TranGridView_MatrixEnter(r,c,ctl){
         
        if(c==0){
            
            var loc = fmStockSCRAP.Form.getControlKey("loc").Text;

            if(loc!="")
            {
                var vl = ctl.Text;
                var aj = new HC_Ajax("lstAvailableStock");
                aj.addFormData("loc",fmStockSCRAP.Form.getControlKey("loc").Text);
                aj.CallServer(function(data){
                    ctl.GridView.enablePaging(5);
                    ctl.GridView.populateUsingJSON_Blank(data);
                    ctl.setText(vl);
                    
                });
            }
        }
    }
     
}catch(e){alert(e);}





try{
                            
    var fmStockReserve = new HC_TransactionForms("fmStockReserve");
    jsonStockReserve = [
        {cnm:"id",width:"80",lbl:"ID",placeholder:"",ctp:"TB",required:"N",vtp:"S",validERR:"",ro:"Y",maxlen:"",nextctl:"descp",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"R0",bscol:"4",group:"",tab:"",tabtitle:""},
        {cnm:"cdt",width:"180",lbl:"Date",placeholder:"",ctp:"TB",required:"Y",vtp:"S",validERR:"",ro:"Y",maxlen:"",nextctl:"descp",json:"",ajaxid:"",selidcol:"id",selcol:"",showcol:"",whcol:"",row:"R0",bscol:"4",group:"",tab:"",tabtitle:"",ACColWidth:""},
        {cnm:"loc",width:"60",lbl:"Location",placeholder:"",ctp:"ACList",required:"Y",vtp:"S",validERR:"",ro:"N",maxlen:"",nextctl:"descp",json:"",ajaxid:"lstLocation",selidcol:"loc",selcol:"loc",showcol:"loc",whcol:"loc",ACColWidth:"",row:"R0",bscol:"4",group:"",tab:"",tabtitle:""},
        {cnm:"descp",width:"80",lbl:"Description",placeholder:"",ctp:"TB",required:"Y",vtp:"S",validERR:"",ro:"N",maxlen:"",nextctl:"GridView",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"",bscol:"",group:"",tab:"",tabtitle:"",ACColWidth:""},
        {cnm:"cby",width:"60",lbl:"UID",placeholder:"",ctp:"TB",required:"Y",vtp:"S",validERR:"",ro:"Y",maxlen:"",nextctl:"GridView",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",ACColWidth:"",row:"R3",bscol:"6",group:"",tab:"",tabtitle:""},
        {cnm:"cnm",width:"60",lbl:"UserName",placeholder:"",ctp:"TB",required:"N",vtp:"S",validERR:"",ro:"Y",maxlen:"",nextctl:"GridView",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",ACColWidth:"",row:"R3",bscol:"6",group:"",tab:"",tabtitle:""}
   ];

    
   fmStockReserve.Form.Heading = "Stock Reserve Process (Stock Reserve)";
   fmStockReserve.Form.WhereColumn = "id";
   fmStockReserve.Form.AssignFields(JSON.stringify(jsonStockReserve));
   fmStockReserve.Form.FirstFocusControl = "loc";
   fmStockReserve.Form.SearchColumns = "id";
   fmStockReserve.PrimaryColumn = "id";
   fmStockReserve.Form.ExternalValidationEnable = true;
   fmStockReserve.Form.ModalType = "XL";
   jsonTranStockReserve = [
        {editable:"Y",required:"Y",width:"100",cnm:"itid",lbl:"Item ID",ctp:"ACList",vtp:"S",maxlen:"",json:"",ajaxid:"",selidcol:"itid",selcol:"itid",showcol:"itid,mtcd,material,loc,make,avl",whcol:"mtcd,material",ACColWidth:"0:70,1:100,2:250,3:150,4:150,5:80,H:300,W:800"},
        {editable:"N",required:"N",width:"90",cnm:"mtcd",lbl:"UMC No",ctp:"TB",vtp:"S",maxlen:"",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",ACColWidth:""},
        {editable:"N",required:"N",width:"220",cnm:"material",lbl:"Material",ctp:"TB",vtp:"S",maxlen:"",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",ACColWidth:""},
        {editable:"N",required:"N",width:"150",cnm:"make",lbl:"Make",ctp:"TB",vtp:"S",maxlen:"",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",ACColWidth:""},
        {editable:"N",required:"N",width:"150",cnm:"loc",lbl:"Location",ctp:"TB",vtp:"S",maxlen:"",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",ACColWidth:""},
        {editable:"N",required:"N",width:"80",cnm:"avl",lbl:"Stock",ctp:"TB",vtp:"S",maxlen:"",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",ACColWidth:""},
        {editable:"Y",required:"Y",width:"80",cnm:"iss",lbl:"Reserve",ctp:"TB",vtp:"S",maxlen:"",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",ACColWidth:""},
        {editable:"N",required:"N",width:"80",cnm:"bal",lbl:"Available",ctp:"TB",vtp:"ND",maxlen:"",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:""}
     ];

     fmStockReserve.TranGridJSON = jsonTranStockReserve;

     function fmStockReserve_Open()
     {
        fmStockReserve.Form.getControlKey("cdt").setText(GP.sysdate);
        fmStockReserve.Form.getControlKey("cby").setText(GP.uid);
        fmStockReserve.Form.getControlKey("cnm").setText(GP.unm);
     }
     
     function fmStockReserve_ExternalValidation()
     {
        return fmStockReserve.TranGridView.validateGridView();
     }

     function fmStockReserve_SaveFormEnd()
     {
        alert("Stock Reservation Process Successfully Completed . . . Please check your stock"); 
        location.reload();
     }
     
     
     function fmStockReserve_inList(json){
         var itid,mtcd,material,make,loc;
         for(var i=0;i<fmStockReserve.TranGridView.GridView.getRowLength();i++){
             itid = fmStockReserve.TranGridView.GridView.getHTML(i,0);
             mtcd = fmStockReserve.TranGridView.GridView.getHTML(i,1);
             material = fmStockReserve.TranGridView.GridView.getHTML(i,2);
             make = fmStockReserve.TranGridView.GridView.getHTML(i,3);
             loc = fmStockReserve.TranGridView.GridView.getHTML(i,4);
             
             if(itid==json.itid && mtcd==json.mtcd && material==json.material && make==json.make && loc==json.loc)
                 return true;
         }
         return false;
     }
     
     function fmStockReserve_TranGridView_DataSelected(r,c,json){
         if(c==0){
             if(json!=null){
                if(!fmStockOUT_inList(json)){
                    fmStockReserve.TranGridView.GridView.setHTML(r,1,json.mtcd);
                    fmStockReserve.TranGridView.GridView.setHTML(r,2,json.material);
                    fmStockReserve.TranGridView.GridView.setHTML(r,3,json.make);
                    fmStockReserve.TranGridView.GridView.setHTML(r,4,json.loc);
                    fmStockReserve.TranGridView.GridView.setHTML(r,5,json.avl);
                }
                else{
                    alert("Material Already Selected In List Please Choose Another Material");
                    (new HC_DelayCall()).Call(function(){
                        fmStockReserve.TranGridView.setFocusGridView(r,0);
                    });
                }
             }
         }
     }
     
     function fmStockReserve_TranGridView_MatrixLeave(r,c,ctl){
         
         if(c==6){
                var avl,iss;
                
                avl = eval(fmStockReserve.TranGridView.GridView.getHTML(r,5));
                iss = eval(fmStockReserve.TranGridView.GridView.getHTML(r,6));
                
                if(iss>avl){
                    alert("Cannot issue more than available quanity : " + avl);
                    (new HC_DelayCall()).Call(function(){
                        fmStockReserve.TranGridView.setFocusGridView(r,6);
                    });
                    
                }
                else{
                    fmStockReserve.TranGridView.GridView.setHTML(r,7,(avl-iss));
                }
             
         }
     }


     function fmStockReserve_TranGridView_MatrixEnter(r,c,ctl){
         
        if(c==0){
            
            var loc = fmStockReserve.Form.getControlKey("loc").Text;


            if(loc!="")
            {
                var aj = new HC_Ajax("lstAvailableStock");
                aj.addFormData("loc",fmStockReserve.Form.getControlKey("loc").Text);
                aj.CallServer(function(data){
                    ctl.GridView.populateUsingJSON(data);
                });
            }
            else{
                alert("Please select any location");
                fmStockReserve.Form.getControlKey("loc").setFocus();
                fmStockReserve.TranGridView.RemoveGridControl();
                fmStockReserve.TranGridView.ActiveCol = -1;
                fmStockReserve.TranGridView.ActiveRow = -1;
            }
        }
    }
     
     
}catch(e){alert(e);}





try{
                            
    var fmStockAdjustment = new HC_TransactionForms("fmStockAdjustment");
    jsonStockAdjustment = [
        {cnm:"id",width:"80",lbl:"ID",placeholder:"",ctp:"TB",required:"N",vtp:"S",validERR:"",ro:"Y",maxlen:"",nextctl:"descp",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"R0",bscol:"6",group:"",tab:"",tabtitle:""},
        {cnm:"loc",width:"60",lbl:"Location",placeholder:"",ctp:"TB",required:"Y",vtp:"S",validERR:"",ro:"Y",maxlen:"",nextctl:"descp",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",ACColWidth:"",row:"R0",bscol:"6",group:"",tab:"",tabtitle:""},
        {cnm:"descp",width:"80",lbl:"Description",placeholder:"",ctp:"TB",required:"N",vtp:"S",validERR:"",ro:"N",maxlen:"",nextctl:"dt",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"",bscol:"",group:"",tab:"",tabtitle:"",ACColWidth:""},
        {cnm:"dt",width:"180",lbl:"Date",placeholder:"",ctp:"TBDate",required:"Y",vtp:"S",validERR:"",ro:"N",maxlen:"",nextctl:"GridView",json:"",ajaxid:"",selidcol:"id",selcol:"",showcol:"",whcol:"",row:"R1",bscol:"3",group:"",tab:"",tabtitle:"",ACColWidth:""},
        {cnm:"cdt",width:"180",lbl:"Date",placeholder:"",ctp:"TB",required:"Y",vtp:"S",validERR:"",ro:"Y",maxlen:"",nextctl:"GridView",json:"",ajaxid:"",selidcol:"id",selcol:"",showcol:"",whcol:"",row:"R1",bscol:"3",group:"",tab:"",tabtitle:"",ACColWidth:""},
        {cnm:"cby",width:"60",lbl:"UID",placeholder:"",ctp:"TB",required:"Y",vtp:"S",validERR:"",ro:"Y",maxlen:"",nextctl:"GridView",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",ACColWidth:"",row:"R1",bscol:"3",group:"",tab:"",tabtitle:""},
        {cnm:"cnm",width:"60",lbl:"UserName",placeholder:"",ctp:"TB",required:"N",vtp:"S",validERR:"",ro:"Y",maxlen:"",nextctl:"GridView",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",ACColWidth:"",row:"R1",bscol:"3",group:"",tab:"",tabtitle:""}
   ];

    fmStockAdjustment.Form.Heading = "Stock Adjustment Process (Stock Adjustments)";
    fmStockAdjustment.Form.WhereColumn = "id";
    fmStockAdjustment.Form.AssignFields(JSON.stringify(jsonStockAdjustment));
    fmStockAdjustment.Form.FirstFocusControl = "dt";
    fmStockAdjustment.Form.SearchColumns = "id";
    fmStockAdjustment.PrimaryColumn = "id";
    fmStockAdjustment.Form.ExternalValidationEnable = true;
    fmStockAdjustment.Form.ModalType = "XL";
    
    jsonTranStockAdjustment = [
        {editable:"Y",required:"Y",width:"70",cnm:"itid",lbl:"Item ID",ctp:"ACList",vtp:"S",maxlen:"",json:"",ajaxid:"",selidcol:"itid",selcol:"itid",showcol:"itid,mtcd,material,loc,sloc,ssloc,make,avl,critical,uom,skid",whcol:"mtcd,material",ACColWidth:"0:70,1:100,2:200,3:120,4:120,5:90,6:90,7:80,8:100,H:200,W:950"},
        {editable:"N",required:"N",width:"90",cnm:"mtcd",lbl:"UMC No",ctp:"TB",vtp:"S",maxlen:"",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",ACColWidth:""},
        {editable:"N",required:"N",width:"180",cnm:"material",lbl:"Material",ctp:"TB",vtp:"S",maxlen:"",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",ACColWidth:""},
        {editable:"N",required:"N",width:"120",cnm:"loc",lbl:"Location",ctp:"TB",vtp:"S",maxlen:"",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",ACColWidth:""},
        {editable:"N",required:"N",width:"120",cnm:"make",lbl:"Make",ctp:"ACList",vtp:"S",maxlen:"",json:"",ajaxid:"",selidcol:"make",selcol:"make",showcol:"make",whcol:"make",ACColWidth:"0:250,H:100,W:300"},
        {editable:"N",required:"N",width:"120",cnm:"sloc",lbl:"Sub Loc",ctp:"ACList",vtp:"S",maxlen:"",json:"",ajaxid:"",selidcol:"sloc",selcol:"sloc",showcol:"sloc",whcol:"sloc",ACColWidth:"0:250,H:100,W:300"},
        {editable:"N",required:"N",width:"120",cnm:"ssloc",lbl:"Rack",ctp:"ACList",vtp:"S",maxlen:"",json:"",ajaxid:"",selidcol:"ssloc",selcol:"ssloc",showcol:"ssloc",whcol:"ssloc",ACColWidth:"0:250,H:100,W:300"},
        {editable:"N",required:"N",width:"70",cnm:"pqty",lbl:"Stock",ctp:"TB",vtp:"S",maxlen:"",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",ACColWidth:""},
        {editable:"Y",required:"Y",width:"70",cnm:"qty",lbl:"New Stock",ctp:"TB",vtp:"D",maxlen:"",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",ACColWidth:""},
        {editable:"N",required:"N",width:"70",cnm:"nqty",lbl:"Available",ctp:"TB",vtp:"S",maxlen:"",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:""},
        {editable:"N",required:"N",width:"70",cnm:"act",lbl:"Changes",ctp:"TB",vtp:"ND",maxlen:"",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:""},
        {editable:"N",required:"N",width:"80",cnm:"critical",lbl:"Critical",ctp:"TB",vtp:"S",maxlen:"",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",ACColWidth:""},
        {editable:"N",required:"N",width:"60",cnm:"uom",lbl:"UOM",ctp:"TB",vtp:"S",maxlen:"",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",ACColWidth:""},
        {editable:"N",required:"N",width:"70",cnm:"skid",lbl:"Stock ID",ctp:"TB",vtp:"S",maxlen:"",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",ACColWidth:""},
        {editable:"Y",required:"N",width:"320",cnm:"rem",lbl:"Remarks",ctp:"TB",vtp:"S",maxlen:"",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",ACColWidth:""}
     ];

     fmStockAdjustment.TranGridJSON = jsonTranStockAdjustment;

     function fmStockAdjustment_ispno_DataSelected(json){
        fmStockAdjustment.Form.getControlKey("isto").setText(json.enm);
     }

     function fmStockAdjustment_tknspno_DataSelected(json){
        fmStockAdjustment.Form.getControlKey("tknby").setText(json.ctnm);  
     }

     function fmStockAdjustment_Open(cnt,msg)
     {
        
        fmStockAdjustment.TranGridView.GridView.SelectMode = "C";
        fmStockAdjustment.TranGridView.GridView.setGridViewHeight(350);
        
        fmStockAdjustment.TranGridView.GridView.setDefaultWidth(true);
        fmStockAdjustment.TranGridView.GridView.setScrollBarY(true);
        fmStockAdjustment.TranGridView.GridView.setScrollBarX(true);
            
        (new HC_DelayCall()).Call(function(){
            fmStockAdjustment.Form.getControlKey("loc").setText(GP.loc);
            fmStockAdjustment.Form.getControlKey("dt").setText(GP.sysdate);
            fmStockAdjustment.Form.getControlKey("cdt").setText(GP.sysdate);
            fmStockAdjustment.Form.getControlKey("cby").setText(GP.uid);
            fmStockAdjustment.Form.getControlKey("cnm").setText(GP.unm);
        });
        
        if(msg=="Open_Form_Modal_KEY_ReadOnly"){
            
            fmStockAdjustment.TranGridView.GridView.setSearching(); 
            fmStockAdjustment.TranGridView.GridView.enablePaging(6);
       
        }
        
     }
     
     function fmStockAdjustment_ExternalValidation()
     {
        return fmStockAdjustment.TranGridView.validateGridView();
     }

     function fmStockAdjustment_SaveFormEnd()
     {
        alert("Stock Adjustment Process Successfully Completed . . . Please check your stock"); 
        location.reload();
     }
     
     function fmStockAdjustment_inList(json,ri){
         var itid,mtcd,material,make,loc,sloc,ssloc;
         if(json.material!=""){
            for(var i=0;i<fmStockAdjustment.TranGridView.GridView.getRowLength();i++){
                if(i!=ri){
                itid = fmStockAdjustment.TranGridView.GridView.getHTML(i,0);
                mtcd = fmStockAdjustment.TranGridView.GridView.getHTML(i,1);
                material = fmStockAdjustment.TranGridView.GridView.getHTML(i,2);
                make = fmStockAdjustment.TranGridView.GridView.getHTML(i,3);
                loc = fmStockAdjustment.TranGridView.GridView.getHTML(i,4);
                sloc = fmStockAdjustment.TranGridView.GridView.getHTML(i,5);
                ssloc = fmStockAdjustment.TranGridView.GridView.getHTML(i,6);

                if(itid==json.itid && mtcd==json.mtcd && material==json.material && make==json.make && loc==json.loc && sloc==json.sloc && ssloc==json.ssloc)
                    return true;
                }
            }
         }
         return false;
     }
     
     function fmStockAdjustment_TranGridView_DataSelected(r,c,json){
         if(c==0){
             if(json!=null){
                if(!fmStockAdjustment_inList(json,r)){
                    if(json.material!=""){
                        fmStockAdjustment.TranGridView.GridView.setHTML(r,1,json.mtcd);
                        fmStockAdjustment.TranGridView.GridView.setHTML(r,2,json.material);
                        fmStockAdjustment.TranGridView.GridView.setHTML(r,3,json.loc);
                        fmStockAdjustment.TranGridView.GridView.setHTML(r,4,json.make);
                        fmStockAdjustment.TranGridView.GridView.setHTML(r,5,json.sloc);
                        fmStockAdjustment.TranGridView.GridView.setHTML(r,6,json.ssloc);
                        fmStockAdjustment.TranGridView.GridView.setHTML(r,7,json.avl);
                        fmStockAdjustment.TranGridView.GridView.setHTMLKey(r,"critical",json.critical);
                        fmStockAdjustment.TranGridView.GridView.setHTMLKey(r,"uom",json.uom);
                        fmStockAdjustment.TranGridView.GridView.setHTMLKey(r,"skid",json.skid);
                    }
                }
                else{
                    alert("Material Already Selected In List Please Choose Another Material");
                    (new HC_DelayCall()).Call(function(){
                        fmStockAdjustment.TranGridView.setFocusGridView(r,0);
                    });
                }
             }
         }
     }
     
     function fmStockAdjustment_TranGridView_MatrixLeave(r,c,ctl){
         
          if(c==0 || c==10)
          {
             if(ctl.GridView.getJSON().length==0){
                 alert("Invalid Item Selected : ");
                 var vl = ctl.Text;
                 (new HC_DelayCall()).Call(function(){
                    fmStockAdjustment.TranGridView.GridView.setHTML(r,c,vl); 
                    fmStockAdjustment.TranGridView.setFocusGridView(r,c);
                 });
             }
         }
         
         if(c==8){
                var avl,iss;
                
                avl = eval(fmStockAdjustment.TranGridView.GridView.getHTML(r,7));
                iss = eval(fmStockAdjustment.TranGridView.GridView.getHTML(r,8));
                
                if(iss<0){
                    alert("Quantity cannot be less then 0 Zero ");
                    (new HC_DelayCall()).Call(function(){
                        fmStockOUT.TranGridView.setFocusGridView(r,8);
                    });
                }
                else{
                    fmStockAdjustment.TranGridView.GridView.setHTML(r,9,(iss));
                    if(iss>avl){
                        fmStockAdjustment.TranGridView.GridView.setHTML(r,10,(iss-avl));
                    }
                    else{
                        fmStockAdjustment.TranGridView.GridView.setHTML(r,10,(avl-iss));
                    }
                }
         }
     }

     function fmStockAdjustment_TranGridView_MatrixEnter(r,c,ctl){
         
        if(c==0){
            
            var loc = fmStockAdjustment.Form.getControlKey("loc").Text;

            if(loc!="")
            {
                var vl = ctl.Text;
                var aj = new HC_Ajax("lstAvailableStock");
                aj.addFormData("loc",fmStockAdjustment.Form.getControlKey("loc").Text);
                aj.CallServer(function(data){
                    ctl.GridView.enablePaging(5);
                    ctl.GridView.populateUsingJSON_Blank(data);
                    ctl.setText(vl);
                    
                });
            }
        }
        
        if(c==6 || c==4 || c==5)
             ctl.ComboBox = true;
             
             if(c==4){
                var vl = ctl.Text;
                var aj = new HC_Ajax("lstMake");
                aj.CallServer(function(data){
                    ctl.GridView.enablePaging(5);
                    ctl.GridView.populateUsingJSON(data);
                    ctl.setText(vl);
                });
             }
             
             if(c==5){
                var vl = ctl.Text;
                var aj = new HC_Ajax("lstSubLoc");
                aj.addFormData("loc",GP.loc,GP.loc);
                aj.CallServer(function(data){
                    ctl.GridView.enablePaging(5);
                    ctl.GridView.populateUsingJSON_Blank(data);
                    ctl.setText(vl);
                });
             }
             
             if(c==6){
                var vl = ctl.Text;
                var aj = new HC_Ajax("lstSubSubLoc");
                aj.addFormData("loc",GP.loc,GP.loc);
                aj.CallServer(function(data){
                    ctl.GridView.enablePaging(5);
                    ctl.GridView.populateUsingJSON_Blank(data);
                    ctl.setText(vl);
                });
             }
    }
     
}catch(e){alert(e);}

var jsonQueryStock = [
    {cnm:"mtcd",lbl:"UMC",placeholder:"",text:"",value:"",ctp:"String",vtp:"",ro:"",container:"",maxlen:"",nextctl:"",json:null,ajaxid:"",selidcol:"",selcol:"",whcol:"",showcol:"",row:"R1",bscol:"3",group:"",tab:"",tabtitle:"",ACColWidth:"0:200,W:230,H:200"},
    {cnm:"uom",lbl:"UOM",placeholder:"",text:"",value:"",ctp:"AutoComplete",vtp:"",ro:"",container:"",maxlen:"",nextctl:"",json:null,ajaxid:"lstStockUOM",selidcol:"uom",selcol:"uom",whcol:"uom",showcol:"uom",row:"R1",bscol:"3",group:"",tab:"",tabtitle:"",ACColWidth:"0:200,W:230,H:200"},
    {cnm:"material",lbl:"Material",placeholder:"",text:"",value:"",ctp:"String",vtp:"",ro:"",container:"",maxlen:"",nextctl:"",json:null,ajaxid:"",selidcol:"",selcol:"",whcol:"",showcol:"",row:"R1",bscol:"6",group:"",tab:"",tabtitle:"",ACColWidth:"0:200,W:230,H:200"},
    {cnm:"make",lbl:"Make",placeholder:"",text:"",value:"",ctp:"AutoComplete",vtp:"",ro:"",container:"",maxlen:"",nextctl:"",json:null,ajaxid:"lstStockMake",selidcol:"make",selcol:"make",whcol:"make",showcol:"make",row:"R2",bscol:"3",group:"",tab:"",tabtitle:"",ACColWidth:"0:200,W:230,H:200"},
    {cnm:"loc",lbl:"Location",placeholder:"",text:"",value:"",ctp:"AutoComplete",vtp:"",ro:"",container:"",maxlen:"",nextctl:"",json:null,ajaxid:"lstStockLoc",selidcol:"loc",selcol:"loc",whcol:"loc",showcol:"loc",row:"R2",bscol:"3",group:"",tab:"",tabtitle:"",ACColWidth:"0:200,W:230,H:200"},
    {cnm:"sloc",lbl:"Sub Location",placeholder:"",text:"",value:"",ctp:"AutoComplete",vtp:"",ro:"",container:"",maxlen:"",nextctl:"",json:null,ajaxid:"lstStockSubLoc",selidcol:"sloc",selcol:"sloc",whcol:"sloc",showcol:"sloc",row:"R2",bscol:"3",group:"",tab:"",tabtitle:"",ACColWidth:"0:200,W:230,H:200"},
    {cnm:"ssloc",lbl:"Rack",placeholder:"",text:"",value:"",ctp:"AutoComplete",vtp:"",ro:"",container:"",maxlen:"",nextctl:"",json:null,ajaxid:"lstStockRack",selidcol:"ssloc",selcol:"ssloc",whcol:"ssloc",showcol:"ssloc",row:"R2",bscol:"3",group:"",tab:"",tabtitle:"",ACColWidth:"0:200,W:230,H:200"},
    {cnm:"avl",lbl:"Available",placeholder:"",text:"",value:"",ctp:"Number",vtp:"",ro:"",container:"",maxlen:"",nextctl:"",json:null,ajaxid:"",selidcol:"",selcol:"",whcol:"",showcol:"",row:"R3",bscol:"4",group:"",tab:"",tabtitle:"",ACColWidth:""},
    {cnm:"sti",lbl:"Stock IN",placeholder:"",text:"",value:"",ctp:"Number",vtp:"",ro:"",container:"",maxlen:"",nextctl:"",json:null,ajaxid:"",selidcol:"",selcol:"",whcol:"",showcol:"",row:"R3",bscol:"4",group:"",tab:"",tabtitle:"",ACColWidth:""},
    {cnm:"sto",lbl:"Stock OUT",placeholder:"",text:"",value:"",ctp:"Number",vtp:"",ro:"",container:"",maxlen:"",nextctl:"",json:null,ajaxid:"",selidcol:"",selcol:"",whcol:"",showcol:"",row:"R3",bscol:"4",group:"",tab:"",tabtitle:"",ACColWidth:""}
   ];

var qvStock = new HC_Query("qvStock");
qvStock.AssignFields(jsonQueryStock,[]);
qvStock.setHeading("Searching of Stock");

try{
                            
    var fmAmcIn = new HC_Forms("fmAmcIn");
    jsonAmcIn = [
        {cnm:"id",width:"100",lbl:"ID",placeholder:"",ctp:"TB",required:"N",vtp:"S",validERR:"",ro:"Y",maxlen:"",nextctl:"hsncode",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"",bscol:"",group:"",tab:"",tabtitle:""},
        {cnm:"astp",width:"350",lbl:"Server Type",placeholder:"",ctp:"ACList",required:"Y",vtp:"S",validERR:"",ro:"N",maxlen:"",nextctl:"loc",json:"",ajaxid:"lstAssetTP",selidcol:"astp",selcol:"astp",showcol:"astp",whcol:"astp",row:"R0",bscol:"6",group:"",tab:"",tabtitle:"",ACColWidth:"0:200,W:230,H:200"},
        {cnm:"loc",width:"350",lbl:"Location",placeholder:"",ctp:"ACList",required:"Y",vtp:"S",validERR:"",ro:"N",maxlen:"",nextctl:"ascmp",json:"",ajaxid:"lstAssetLoc",selidcol:"loc",selcol:"loc",showcol:"loc",whcol:"loc",row:"R0",bscol:"6",group:"",tab:"",tabtitle:"",ACColWidth:"0:200,W:230,H:200"},
        {cnm:"ascmp",width:"350",lbl:"Company",placeholder:"",ctp:"ACList",required:"Y",vtp:"S",validERR:"",ro:"N",maxlen:"",nextctl:"make",json:"",ajaxid:"lstAssetComp",selidcol:"company",selcol:"company",showcol:"company",whcol:"company",row:"R1",bscol:"6",group:"",tab:"",tabtitle:"",ACColWidth:"0:200,W:230,H:200"},
        {cnm:"make",width:"350",lbl:"Make",placeholder:"",ctp:"ACList",required:"Y",vtp:"S",validERR:"",ro:"N",maxlen:"",nextctl:"model",json:"",ajaxid:"lstAssetMake",selidcol:"make",selcol:"make",showcol:"make",whcol:"make",row:"R1",bscol:"6",group:"",tab:"",tabtitle:"",ACColWidth:"0:200,W:230,H:200"},
        {cnm:"model",width:"350",lbl:"Model",placeholder:"",ctp:"TB",required:"Y",vtp:"S",validERR:"",ro:"N",maxlen:"",nextctl:"qty",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"R2",bscol:"6",group:"",tab:"",tabtitle:""},
        {cnm:"qty",width:"350",lbl:"Quantity",placeholder:"",ctp:"TB",required:"Y",vtp:"S",validERR:"",ro:"N",maxlen:"",nextctl:"qty",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"R2",bscol:"6",group:"",tab:"",tabtitle:""}
    ];

    fmAmcIn.Heading = "New Asset Entry";
    fmAmcIn.WhereColumn = "id";
    fmAmcIn.AssignFields(JSON.stringify(jsonAmcIn));
    fmAmcIn.FirstFocusControl = "astp";
    fmAmcIn.SearchColumns = "model";
    fmAmcIn.ExternalValidationEnable = true;

}catch(e){alert(e);}


try{
                            
    var fmEnquiry = new HC_Forms("fmEnquiry");
    jsonEnquiry = [
        {cnm:"id",width:"100",lbl:"ID",placeholder:"",ctp:"TB",required:"N",vtp:"S",validERR:"",ro:"Y",maxlen:"",nextctl:"hsncode",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"R0",bscol:"6",group:"",tab:"",tabtitle:""},
        {cnm:"uid",width:"350",lbl:"Server Type",placeholder:"",ctp:"TB",required:"Y",vtp:"S",validERR:"",ro:"Y",maxlen:"",nextctl:"loc",json:"",ajaxid:"",selidcol:"astp",selcol:"astp",showcol:"astp",whcol:"astp",row:"R0",bscol:"6",group:"",tab:"",tabtitle:"",ACColWidth:""},
        {cnm:"dt",width:"350",lbl:"Date",placeholder:"",ctp:"TB",required:"Y",vtp:"S",validERR:"",ro:"Y",maxlen:"",nextctl:"ascmp",json:"",ajaxid:"",selidcol:"loc",selcol:"loc",showcol:"loc",whcol:"loc",row:"R1",bscol:"6",group:"",tab:"",tabtitle:"",ACColWidth:""},
        {cnm:"loc",width:"350",lbl:"Location",placeholder:"",ctp:"TB",required:"Y",vtp:"S",validERR:"",ro:"Y",maxlen:"",nextctl:"ascmp",json:"",ajaxid:"",selidcol:"loc",selcol:"loc",showcol:"loc",whcol:"loc",row:"R1",bscol:"6",group:"",tab:"",tabtitle:"",ACColWidth:""},
        {cnm:"model",width:"350",lbl:"Model",placeholder:"",ctp:"TB",required:"Y",vtp:"S",validERR:"",ro:"N",maxlen:"",nextctl:"make",json:"",ajaxid:"",selidcol:"company",selcol:"company",showcol:"company",whcol:"company",row:"R2",bscol:"4",group:"",tab:"",tabtitle:"",ACColWidth:""},
        {cnm:"part",width:"350",lbl:"Part",placeholder:"",ctp:"TB",required:"Y",vtp:"S",validERR:"",ro:"N",maxlen:"",nextctl:"model",json:"",ajaxid:"",selidcol:"make",selcol:"make",showcol:"make",whcol:"make",row:"R2",bscol:"4",group:"",tab:"",tabtitle:"",ACColWidth:""},
        {cnm:"asstid",width:"350",lbl:"AssetID",placeholder:"",ctp:"TB",required:"Y",vtp:"S",validERR:"",ro:"N",maxlen:"",nextctl:"model",json:"",ajaxid:"",selidcol:"make",selcol:"make",showcol:"make",whcol:"make",row:"R2",bscol:"4",group:"",tab:"",tabtitle:"",ACColWidth:""},
        {cnm:"partd",width:"350",lbl:"Part Descp",placeholder:"",ctp:"TB",required:"Y",vtp:"S",validERR:"",ro:"N",maxlen:"",nextctl:"qty",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"",bscol:"",group:"",tab:"",tabtitle:""},
        {cnm:"rem",width:"350",lbl:"Remarks",placeholder:"",ctp:"TB",required:"Y",vtp:"S",validERR:"",ro:"N",maxlen:"",nextctl:"qty",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"",bscol:"",group:"",tab:"",tabtitle:""}
    ];

    fmEnquiry.Heading = "New Enquiry Entry";
    fmEnquiry.WhereColumn = "id";
    fmEnquiry.AssignFields(JSON.stringify(jsonEnquiry));
    fmEnquiry.FirstFocusControl = "model";
    fmEnquiry.SearchColumns = "model,part";
    fmEnquiry.ExternalValidationEnable = true;
    fmEnquiry.ReadOnly = true;
    
    
    function fmEnquiry_Open(cnt,optp){
        if(optp=="Open_Form"){
            fmEnquiry.getControlKey("uid").setText(GP.uid);
            fmEnquiry.getControlKey("loc").setText(GP.loc);
            fmEnquiry.getControlKey("dt").setText(GP.sysdate);
        }
    }

}catch(e){alert(e);}


//server


//System Organization Starts

/////hr_master start
//empid,enm,doj,desig,loc,bnk,bnk_acc,sex,un_no,pf_no,esi_no,adrs,cnt,mail,emrg_cnt,nomnee,bgrp


try{
                            
    var fmHrMaster = new HC_Forms("fmHrMaster");       //bnk,bnk_acc,sex,un_no,pf_no,esi_no,adrs,cnt,mail,emrg_cnt,nomnee,bgrp
    jsonHrMaster = [
        {cnm:"empid",width:"100",lbl:"Employee No:",placeholder:"",ctp:"TB",required:"N",vtp:"S",validERR:"",ro:"Y",maxlen:"",nextctl:"hsncode",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"R0",bscol:"6",group:"",tab:"",tabtitle:""},
        {cnm:"enm",width:"350",lbl:"Employee Name",placeholder:"",ctp:"TB",required:"Y",vtp:"S",validERR:"",ro:"N",maxlen:"",nextctl:"doj",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"R0",bscol:"6",group:"",tab:"",tabtitle:""},
        {cnm:"doj",width:"100",lbl:"Date of Joining",placeholder:"",ctp:"TBDate",required:"N",vtp:"S",validERR:"N",ro:"n",maxlen:"",nextctl:"desig",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"R1",bscol:"6",group:"",tab:"",tabtitle:""},
        {cnm:"desig",width:"100",lbl:"Designation",placeholder:"",ctp:"TB",required:"N",vtp:"S",validERR:"",ro:"N",maxlen:"",nextctl:"loc",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"R1",bscol:"6",group:"",tab:"",tabtitle:""},
        {cnm:"loc",width:"100",lbl:"Location",placeholder:"",ctp:"TB",required:"N",vtp:"S",validERR:"",ro:"N",maxlen:"",nextctl:"bnk",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"",bscol:"",group:"",tab:"",tabtitle:""},
        {cnm:"bnk",width:"100",lbl:"Bank",placeholder:"",ctp:"TB",required:"N",vtp:"S",validERR:"",ro:"N",maxlen:"",nextctl:"bnk_acc",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"",bscol:"",group:"",tab:"",tabtitle:""},
        {cnm:"bnkacc",width:"100",lbl:"Bank Account",placeholder:"",ctp:"TB",required:"N",vtp:"S",validERR:"",ro:"N",maxlen:"",nextctl:"sex",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"",bscol:"",group:"",tab:"",tabtitle:""},
        {cnm:"sex",width:"100",lbl:"Gender",placeholder:"",ctp:"TB",required:"N",vtp:"S",validERR:"",ro:"N",maxlen:"",nextctl:"un_no",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"",bscol:"",group:"",tab:"",tabtitle:""},
        {cnm:"un_no",width:"100",lbl:"UNO",placeholder:"",ctp:"TB",required:"N",vtp:"S",validERR:"",ro:"N",maxlen:"",nextctl:"pf_no",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"",bscol:"",group:"",tab:"",tabtitle:""},
         {cnm:"pfno",width:"100",lbl:"PF No",placeholder:"",ctp:"TB",required:"N",vtp:"S",validERR:"",ro:"N",maxlen:"",nextctl:"esi_no",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"",bscol:"",group:"",tab:"",tabtitle:""},
          {cnm:"esino",width:"100",lbl:"ESIC No",placeholder:"",ctp:"TB",required:"N",vtp:"S",validERR:"",ro:"N",maxlen:"",nextctl:"adrs",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"",bscol:"",group:"",tab:"",tabtitle:""},
           {cnm:"adrs",width:"100",lbl:"Addrss",placeholder:"",ctp:"TB",required:"N",vtp:"S",validERR:"",ro:"N",maxlen:"",nextctl:"cnt",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"",bscol:"",group:"",tab:"",tabtitle:""},
            {cnm:"cnt",width:"100",lbl:"Contact",placeholder:"",ctp:"TB",required:"N",vtp:"S",validERR:"",ro:"N",maxlen:"",nextctl:"mail",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"",bscol:"",group:"",tab:"",tabtitle:""},
             {cnm:"mail",width:"100",lbl:"Mail",placeholder:"",ctp:"TB",required:"N",vtp:"S",validERR:"",ro:"N",maxlen:"",nextctl:"emrg_cnt",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"",bscol:"",group:"",tab:"",tabtitle:""},
              {cnm:"emrgcnt",width:"100",lbl:"Emergancy Cont",placeholder:"",ctp:"TB",required:"N",vtp:"S",validERR:"",ro:"N",maxlen:"",nextctl:"nomnee",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"",bscol:"",group:"",tab:"",tabtitle:""},
               {cnm:"nomnee",width:"100",lbl:"Nomenee",placeholder:"",ctp:"TB",required:"N",vtp:"S",validERR:"",ro:"N",maxlen:"",nextctl:"bgrp",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"",bscol:"",group:"",tab:"",tabtitle:""},
                {cnm:"bgrp",width:"100",lbl:"Blood Group",placeholder:"",ctp:"TB",required:"N",vtp:"S",validERR:"",ro:"N",maxlen:"",nextctl:"bgrp",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"",bscol:"",group:"",tab:"",tabtitle:""}
        
        
    ];

    fmHrMaster.Heading = "New HR Master";
    fmHrMaster.WhereColumn = "eno";
    fmHrMaster.AssignFields(JSON.stringify(jsonHrMaster));
    fmHrMaster.FirstFocusControl = "enm";
    fmHrMaster.SearchColumns = "enm";
    fmHrMaster.ExternalValidationEnable = true;

}catch(e){alert(e);}

//// hr_master end

try{
                            
    var fmArea = new HC_Forms("fmArea");
    jsonArea = [
        {cnm:"id",width:"100",lbl:"Area ID",placeholder:"",ctp:"TB",required:"N",vtp:"S",validERR:"",ro:"Y",maxlen:"",nextctl:"hsncode",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"",bscol:"",group:"",tab:"",tabtitle:""},
        {cnm:"area",width:"350",lbl:"Area",placeholder:"",ctp:"TB",required:"Y",vtp:"S",validERR:"",ro:"N",maxlen:"",nextctl:"gstp",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"",bscol:"",group:"",tab:"",tabtitle:""}
    ];

    fmArea.Heading = "New Area";
    fmArea.WhereColumn = "id";
    fmArea.AssignFields(JSON.stringify(jsonArea));
    fmArea.FirstFocusControl = "area";
    fmArea.SearchColumns = "area";
    fmArea.ExternalValidationEnable = true;

}catch(e){alert(e);}

//server

try{
                            
    var fmServer = new HC_Forms("fmServer");
    jsonServer = [
        {cnm:"id",width:"100",lbl:"Server ID",placeholder:"",ctp:"TB",required:"N",vtp:"S",validERR:"",ro:"Y",maxlen:"",nextctl:"Sertyp",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"",bscol:"",group:"",tab:"",tabtitle:""},
        {cnm:"Sertyp",width:"350",lbl:"Server Type",placeholder:"",ctp:"TB",required:"Y",vtp:"S",validERR:"",ro:"N",maxlen:"",nextctl:"gstp",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"",bscol:"",group:"",tab:"",tabtitle:""}
    ];

    fmServer.Heading = "New Server";
    fmServer.WhereColumn = "id";
    fmServer.AssignFields(JSON.stringify(jsonServer));
    fmServer.FirstFocusControl = "sertyp";
    fmServer.SearchColumns = "sertyp";
    fmServer.ExternalValidationEnable = true;

}catch(e){alert(e);}

//server


//stock input

try{
                            
    var fmServer = new HC_Forms("fmServer");
    jsonServer = [
        {cnm:"id",width:"100",lbl:"Server ID",placeholder:"",ctp:"TB",required:"N",vtp:"S",validERR:"",ro:"Y",maxlen:"",nextctl:"Sertyp",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"",bscol:"",group:"",tab:"",tabtitle:""},
        {cnm:"Sertyp",width:"350",lbl:"Server Type",placeholder:"",ctp:"TB",required:"Y",vtp:"S",validERR:"",ro:"N",maxlen:"",nextctl:"gstp",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"",bscol:"",group:"",tab:"",tabtitle:""}
    ];

    fmServer.Heading = "New Server";
    fmServer.WhereColumn = "id";
    fmServer.AssignFields(JSON.stringify(jsonServer));
    fmServer.FirstFocusControl = "sertyp";
    fmServer.SearchColumns = "sertyp";
    fmServer.ExternalValidationEnable = true;

}catch(e){alert(e);}

//stock input

try{
                            
    var fmGSTRate = new HC_Forms("fmGSTRate");
    jsonGSTRate = [
        {cnm:"id",width:"100",lbl:"ID",placeholder:"",ctp:"TB",required:"N",vtp:"S",validERR:"",ro:"Y",maxlen:"",nextctl:"hsncode",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"",bscol:"",group:"",tab:"",tabtitle:""},
        {cnm:"sertyp",width:"350",lbl:"HSN Code",placeholder:"",ctp:"TB",required:"Y",vtp:"S",validERR:"",ro:"N",maxlen:"",nextctl:"gstp",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"",bscol:"",group:"",tab:"",tabtitle:""},
        {cnm:"id",width:"100",lbl:"ID",placeholder:"",ctp:"TB",required:"N",vtp:"S",validERR:"",ro:"Y",maxlen:"",nextctl:"hsncode",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"",bscol:"",group:"",tab:"",tabtitle:""},
        {cnm:"loc",width:"350",lbl:"HSN Code",placeholder:"",ctp:"TB",required:"Y",vtp:"S",validERR:"",ro:"N",maxlen:"",nextctl:"gstp",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"",bscol:"",group:"",tab:"",tabtitle:""},
        {cnm:"id",width:"100",lbl:"ID",placeholder:"",ctp:"TB",required:"N",vtp:"S",validERR:"",ro:"Y",maxlen:"",nextctl:"hsncode",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"",bscol:"",group:"",tab:"",tabtitle:""},
        {cnm:"id",width:"350",lbl:"HSN Code",placeholder:"",ctp:"TB",required:"Y",vtp:"S",validERR:"",ro:"N",maxlen:"",nextctl:"gstp",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"",bscol:"",group:"",tab:"",tabtitle:""},
        {cnm:"compnm",width:"100",lbl:"ID",placeholder:"",ctp:"TB",required:"N",vtp:"S",validERR:"",ro:"Y",maxlen:"",nextctl:"hsncode",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"",bscol:"",group:"",tab:"",tabtitle:""},
        {cnm:"hsncode",width:"350",lbl:"HSN Code",placeholder:"",ctp:"TB",required:"Y",vtp:"S",validERR:"",ro:"N",maxlen:"",nextctl:"gstp",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"",bscol:"",group:"",tab:"",tabtitle:""},
        {cnm:"gstp",width:"350",lbl:"GST %",placeholder:"",ctp:"TB",required:"Y",vtp:"N",validERR:"",ro:"N",maxlen:"",nextctl:"gstp",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"",bscol:"",group:"",tab:"",tabtitle:""}
    ];

    fmGSTRate.Heading = "New GST Rates Entry";
    fmGSTRate.WhereColumn = "id";
    fmGSTRate.AssignFields(JSON.stringify(jsonGSTRate));
    fmGSTRate.FirstFocusControl = "hsncode";
    fmGSTRate.SearchColumns = "id,hsncode";
    fmGSTRate.ExternalValidationEnable = true;

}catch(e){alert(e);}

try{
                            
    var fmPart = new HC_Forms("fmPart");
    jsonPart = [
        {cnm:"id",width:"60",lbl:"Part No",placeholder:"",ctp:"TB",required:"N",vtp:"S",validERR:"",ro:"Y",maxlen:"",nextctl:"part",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"",bscol:"",group:"",tab:"",tabtitle:""},
        {cnm:"part",width:"150",lbl:"Part Name",placeholder:"",ctp:"TB",required:"Y",vtp:"S",validERR:"",ro:"N",maxlen:"",nextctl:"parttp",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"",bscol:"",group:"",tab:"",tabtitle:""},
        {cnm:"parttp",width:"150",lbl:"Part Type",placeholder:"",ctp:"ACList",required:"Y",vtp:"S",validERR:"",ro:"N",maxlen:"",nextctl:"hsncode",json:"",ajaxid:"acPartTP",selidcol:"id",selcol:"parttp",showcol:"parttp,id",whcol:"parttp",row:"R1",bscol:"6",group:"",tab:"",tabtitle:"",ACColWidth:"0:200,1:60,H:100,W:280"},
        {cnm:"parttpid",width:"80",lbl:"Part Type ID",placeholder:"",ctp:"TB",required:"Y",vtp:"N",validERR:"",ro:"Y",maxlen:"",nextctl:"hsncode",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"R1",bscol:"6",group:"",tab:"",tabtitle:""},
        {cnm:"hsncode",width:"150",lbl:"HSN Code",placeholder:"",ctp:"ACList",required:"Y",vtp:"S",validERR:"",ro:"N",maxlen:"",nextctl:"sts",json:"",ajaxid:"acHSNCode",selidcol:"hsncode",selcol:"hsncode",showcol:"hsncode,gstp",whcol:"hsncode",row:"R2",bscol:"6",group:"",tab:"",tabtitle:"",ACColWidth:"0:200,1:60,H:100,W:280"},
        {cnm:"gstp",width:"80",lbl:"GST %",placeholder:"",ctp:"TB",required:"Y",vtp:"N",validERR:"",ro:"Y",maxlen:"",nextctl:"sts",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"R2",bscol:"6",group:"",tab:"",tabtitle:""},
        {cnm:"sts",width:"100",lbl:"Status",placeholder:"",ctp:"ACList",required:"Y",vtp:"N",validERR:"",ro:"N",maxlen:"",nextctl:"sts",json:[{"id":"Active"},{"id":"Not Active"}],ajaxid:"",selidcol:"id",selcol:"id",showcol:"id",whcol:"id",row:"",bscol:"",group:"",tab:"",tabtitle:"",ACColWidth:"0:200,H:100,W:220"}
    ];

    fmPart.Heading = "New Part Entry and GST %";
    fmPart.WhereColumn = "id";
    fmPart.AssignFields(JSON.stringify(jsonPart));
    fmPart.FirstFocusControl = "part";
    fmPart.SearchColumns = "id,part,hsncode";
    
    
    function fmPart_parttp_DataSelected(json){
        fmPart.getControlKey("parttpid").setText(json.id);
    }
    
    function fmPart_hsncode_DataSelected(json){
        fmPart.getControlKey("gstp").setText(json.gstp);
    }
    
    function fmPart_Open(cnt,evnt){
        if(evnt=="Open_Form_New"){
            fmPart.getControlKey("sts").setText("Active");
        }
    }

}catch(e){alert(e);}


//start of compotype
try{
                            
    var fmPartType = new HC_Forms("fmPartType");
    jsonPartType = [
        {cnm:"id",width:"100",lbl:"ID",placeholder:"",ctp:"TB",required:"N",vtp:"S",validERR:"",ro:"Y",maxlen:"",nextctl:"room",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"",bscol:"",group:"",tab:"",tabtitle:""},
        {cnm:"parttp",width:"350",lbl:"Part Type",placeholder:"",ctp:"TB",required:"Y",vtp:"S",validERR:"",ro:"N",maxlen:"",nextctl:"adds",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"",bscol:"",group:"",tab:"",tabtitle:""}
    ];

    fmPartType.Heading = "New Part Type Entry";
    fmPartType.WhereColumn = "id";
    fmPartType.AssignFields(JSON.stringify(jsonPartType));
    fmPartType.FirstFocusControl = "parttp";
    fmPartType.SearchColumns = "id,parttp";
    fmPartType.ExternalValidationEnable = true;

}catch(e){alert(e);}

//start of compotype
try{
                            
    var fmDealer = new HC_Forms("fmDealer");
    jsonDealer = [
        {cnm:"id",width:"100",lbl:"ID",placeholder:"",ctp:"TB",required:"N",vtp:"S",validERR:"",ro:"Y",maxlen:"",nextctl:"dealer",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"",bscol:"",group:"",tab:"",tabtitle:""},
        {cnm:"dealer",width:"150",lbl:"Dealer",placeholder:"",ctp:"TB",required:"N",vtp:"S",validERR:"",ro:"N",maxlen:"",nextctl:"gstn",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"",bscol:"",group:"",tab:"",tabtitle:""},
        {cnm:"gstn",width:"120",lbl:"GSTN",placeholder:"",ctp:"TB",required:"Y",vtp:"S",validERR:"",ro:"N",maxlen:"",nextctl:"email",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"",bscol:"",group:"",tab:"",tabtitle:""},
        {cnm:"email",width:"150",lbl:"Email",placeholder:"",ctp:"TB",required:"Y",vtp:"S",validERR:"",ro:"N",maxlen:"",nextctl:"phone",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"",bscol:"",group:"",tab:"",tabtitle:""},
        {cnm:"phone",width:"80",lbl:"Phone",placeholder:"",ctp:"TB",required:"Y",vtp:"S",validERR:"",ro:"N",maxlen:"",nextctl:"altphone",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"",bscol:"",group:"",tab:"",tabtitle:""},
        {cnm:"altphone",width:"80",lbl:"Alt Phone",placeholder:"",ctp:"TB",required:"N",vtp:"S",validERR:"",ro:"N",maxlen:"",nextctl:"addr",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"",bscol:"",group:"",tab:"",tabtitle:""},
        {cnm:"addr",width:"150",lbl:"Address",placeholder:"",ctp:"TB",required:"N",vtp:"S",validERR:"",ro:"N",maxlen:"",nextctl:"city",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"",bscol:"",group:"",tab:"",tabtitle:""},
        {cnm:"city",width:"80",lbl:"City",placeholder:"",ctp:"TB",required:"N",vtp:"S",validERR:"",ro:"N",maxlen:"",nextctl:"state",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"",bscol:"",group:"",tab:"",tabtitle:""},
        {cnm:"state",width:"80",lbl:"State",placeholder:"",ctp:"TB",required:"N",vtp:"S",validERR:"",ro:"N",maxlen:"",nextctl:"pincode",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"",bscol:"",group:"",tab:"",tabtitle:""},
        {cnm:"pincode",width:"60",lbl:"Pin Code",placeholder:"",ctp:"TB",required:"N",vtp:"S",validERR:"",ro:"N",maxlen:"",nextctl:"pincode",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"",bscol:"",group:"",tab:"",tabtitle:""}
    ];

    fmDealer.Heading = "New Dealer Entry";
    fmDealer.WhereColumn = "id";
    fmDealer.AssignFields(JSON.stringify(jsonDealer));
    fmDealer.FirstFocusControl = "dealer";
    fmDealer.SearchColumns = "id,dealer";
    fmDealer.ExternalValidationEnable = true;

}catch(e){alert(e);}



//end of Location
////-------------------------------

//start of the manufacture
try{
                            
    var fmManufacture = new HC_Forms("fmManufacture");
    jsonManufacture = [
        {cnm:"id",width:"100",lbl:"Manufacture ID",placeholder:"",ctp:"TB",required:"N",vtp:"S",validERR:"",ro:"Y",maxlen:"",nextctl:"orz",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"",bscol:"",group:"",tab:"",tabtitle:""},
        {cnm:"mnfc",width:"350",lbl:"Manufacture",placeholder:"",ctp:"TB",required:"Y",vtp:"S",validERR:"",ro:"N",maxlen:"",nextctl:"adds",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"",bscol:"",group:"",tab:"",tabtitle:""}
    ];

    fmManufacture.Heading = "New Manufacture Entry";
    fmManufacture.WhereColumn = "id";
    fmManufacture.AssignFields(JSON.stringify(jsonManufacture));
    fmManufacture.FirstFocusControl = "mnfc";
    fmManufacture.SearchColumns = "id,mnfc";
    fmManufacture.ExternalValidationEnable = true;

}catch(e){alert(e);}

//end of manufacture
//----------------------------------------
//start of product type
try{
                            
    var fmProductType = new HC_Forms("fmProductType");
    jsonProductType = [
        {cnm:"id",width:"100",lbl:"Product Type ID",placeholder:"",ctp:"TB",required:"N",vtp:"S",validERR:"",ro:"Y",maxlen:"",nextctl:"orz",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"",bscol:"",group:"",tab:"",tabtitle:""},
        {cnm:"prtp",width:"350",lbl:"Product Type",placeholder:"",ctp:"TB",required:"Y",vtp:"S",validERR:"",ro:"N",maxlen:"",nextctl:"adds",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"",bscol:"",group:"",tab:"",tabtitle:""}
    ];

    fmProductType.Heading = "New Product Type Entry";
    fmProductType.WhereColumn = "id";
    fmProductType.AssignFields(JSON.stringify(jsonProductType));
    fmProductType.FirstFocusControl = "prtp";
    fmProductType.SearchColumns = "id,prtp";
    fmProductType.ExternalValidationEnable = true;

}catch(e){alert(e);}







/*
try{
                            
        var fmStockIN = new HC_Forms("fmStockIN");
        jsonStockIN = [
            {cnm:"id",width:"80",lbl:"ID",placeholder:"",ctp:"TB",required:"N",vtp:"S",validERR:"",ro:"Y",maxlen:"",nextctl:"prtp",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"R0",bscol:"6",group:"",tab:"",tabtitle:""},
            {cnm:"product",width:"60",lbl:"Product",placeholder:"",ctp:"ACList",required:"Y",vtp:"S",validERR:"",ro:"N",maxlen:"",nextctl:"prtp",json:"",ajaxid:"acProduct",selidcol:"prid",selcol:"product",showcol:"product",whcol:"product",ACColWidth:"0:200,W:220",row:"R0",bscol:"6",group:"",tab:"",tabtitle:""},
            {cnm:"prtp",width:"180",lbl:"Product Type",placeholder:"",ctp:"ACList",required:"N",vtp:"S",validERR:"",ro:"N",maxlen:"",nextctl:"mnfc",json:"",ajaxid:"acProductTP",selidcol:"id",selcol:"prtp",showcol:"prtp",whcol:"prtp",row:"R1",bscol:"6",group:"",tab:"",tabtitle:"",ACColWidth:"0:200,W:220"},
            {cnm:"mnfc",width:"130",lbl:"Manufacturer",placeholder:"",ctp:"ACList",required:"",vtp:"S",validERR:"",ro:"N",maxlen:"",nextctl:"GridView",json:"",ajaxid:"acManufacture",selidcol:"id",selcol:"mnfc",showcol:"mnfc",whcol:"mnfc",row:"R1",bscol:"6",group:"",tab:"",tabtitle:"",ACColWidth:"0:200,W:220"}
        ];

        //fmUser.WhereColumn = "uid";
        //fmUser.generateForm("dvuom");
        fmStockIN.Form.Heading = "Stock Entry Screen";
        fmStockIN.Form.WhereColumn = "prid";
        fmStockIN.Form.AssignFields(JSON.stringify(jsonProductStockIN));
        fmStockIN.Form.FirstFocusControl = "product";
        fmProductStockIN.Form.SearchColumns = "prid";
        fmProductStockIN.PrimaryColumn = "prid";
        fmProductStockIN.Form.ExternalValidationEnable = true;
        fmProductStockIN.Form.ModalType = "XL";
        jsonTranProductStockIN = [
            {editable:"Y",required:"Y",width:"120",cnm:"cmp",lbl:"Component",ctp:"ACList",vtp:"S",maxlen:"",json:"",ajaxid:"acComponent",selidcol:"id",selcol:"cmp",showcol:"cmp",whcol:"cmp",ACColWidth:"0:200,H:100,W:230"},
            {editable:"N",required:"N",width:"30",cnm:"cmpid",lbl:"ID",ctp:"TB",vtp:"S",maxlen:"",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",ACColWidth:""},
            {editable:"Y",required:"N",width:"120",cnm:"cmptp",lbl:"Component TP",ctp:"ACList",vtp:"S",maxlen:"",json:"",ajaxid:"acComponentTP",selidcol:"id",selcol:"cmptp",showcol:"cmptp",whcol:"cmptp",ACColWidth:"0:200,H:100,W:230"},
            {editable:"N",required:"N",width:"30",cnm:"cmptpid",lbl:"ID",ctp:"TB",vtp:"S",maxlen:"",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",ACColWidth:""},
            {editable:"Y",required:"N",width:"120",cnm:"mnfc",lbl:"Manufac",ctp:"ACList",vtp:"S",maxlen:"",json:"",ajaxid:"acManufacture",selidcol:"id",selcol:"mnfc",showcol:"mnfc",whcol:"mnfc",ACColWidth:"0:200,H:100,W:230"},
            {editable:"N",required:"N",width:"30",cnm:"mnfcid",lbl:"ID",ctp:"TB",vtp:"S",maxlen:"",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",ACColWidth:""},
            {editable:"Y",required:"N",width:"120",cnm:"loc",lbl:"Location",ctp:"ACList",vtp:"S",maxlen:"",json:"",ajaxid:"acLocation",selidcol:"id",selcol:"loc",showcol:"loc",whcol:"loc",ACColWidth:"0:200,H:100,W:230"},
            {editable:"N",required:"N",width:"30",cnm:"lcid",lbl:"ID",ctp:"TB",vtp:"S",maxlen:"",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",ACColWidth:""},
            {editable:"Y",required:"N",width:"120",cnm:"area",lbl:"Area",ctp:"ACList",vtp:"S",maxlen:"",json:"",ajaxid:"acArea",selidcol:"id",selcol:"area",showcol:"area",whcol:"area",ACColWidth:"0:200,H:100,W:230"},
            {editable:"N",required:"N",width:"30",cnm:"arid",lbl:"ID",ctp:"TB",vtp:"S",maxlen:"",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",ACColWidth:""},
            {editable:"Y",required:"N",width:"120",cnm:"room",lbl:"Room",ctp:"ACList",vtp:"S",maxlen:"",json:"",ajaxid:"acRoom",selidcol:"id",selcol:"room",showcol:"room",whcol:"room",ACColWidth:"0:200,H:100,W:230"},
            {editable:"N",required:"N",width:"30",cnm:"rmid",lbl:"ID",ctp:"TB",vtp:"S",maxlen:"",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",ACColWidth:""},
            {editable:"Y",required:"N",width:"120",cnm:"rack",lbl:"Rack",ctp:"ACList",vtp:"S",maxlen:"",json:"",ajaxid:"acRack",selidcol:"id",selcol:"rack",showcol:"rack",whcol:"rack",ACColWidth:"0:200,H:100,W:230"},
            {editable:"N",required:"N",width:"30",cnm:"rkid",lbl:"ID",ctp:"TB",vtp:"S",maxlen:"",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",ACColWidth:""},
            {editable:"Y",required:"N",width:"100",cnm:"slno",lbl:"SLNO",ctp:"TB",vtp:"S",maxlen:"",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:""},
            {editable:"Y",required:"N",width:"100",cnm:"partno",lbl:"Part NO",ctp:"TB",vtp:"S",maxlen:"",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:""},
            {editable:"Y",required:"N",width:"100",cnm:"rate",lbl:"Rate",ctp:"TB",vtp:"S",maxlen:"",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:""},
            {editable:"Y",required:"N",width:"100",cnm:"qty",lbl:"QTY",ctp:"TB",vtp:"S",maxlen:"",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:""}
         ];

         fmProductStockIN.TranGridJSON = jsonTranProductStockIN;
          
         function fmProductStockIN_TranGridView_MatrixEnter(r,c,cnt){
             if(c==0 || c==1 || c==2 || c==3 || c==4 || c==5 || c==6){
                try{
                cnt.ComboBox = true;
                }catch(e){}
             }
         }
         
         function fmProductStockIN_TranGridView_MatrixEnter(r,c,cnt){
             if(c==0 || c==2 || c==4 || c==6 || c==8 || c==10 || c==12){
                try{
                cnt.ComboBox = true;
                }catch(e){}
             }
         }
         
         function fmProductStockIN_TranGridView_DataSelected(r,c,json){
             if(c==0 || c==2 || c==4 || c==6 || c==8 || c==10 || c==12){
                 if(json!=null)
                    fmProductStockIN.TranGridView.GridView.setHTML(r,(c+1),json.id);
                 else
                     fmProductStockIN.TranGridView.GridView.setHTML(r,(c+1),"");
             }
         }
         
         function fmProductStockIN_Open(cnt,x){
             if(x=="Open_Form_New"){
                 fmProductStockIN.Form.getControlKey("product").ComboBox = true;
                 fmProductStockIN.Form.getControlKey("prtp").ComboBox = true;
                 fmProductStockIN.Form.getControlKey("mnfc").ComboBox = true;
             }
         }

    }catch(e){alert(e);}

*/

    var jsonStockINGridView = [
        {"cnm":"id","lbl":"ID","width":"30"},
        {"cnm":"sl","lbl":"SL No.","width":"30"},
        {"cnm":"model","lbl":"Model","width":"120"},
        {"cnm":"slno","lbl":"Serial","width":"80"},
        {"cnm":"part","lbl":"Part","width":"120"},
        {"cnm":"prtp","lbl":"Part TP","width":"100"},
        {"cnm":"cpct","lbl":"Capacity","width":"60"},
        {"cnm":"descp1","lbl":"Descp1","width":"80"},
        {"cnm":"descp2","lbl":"Descp2","width":"80"},
        {"cnm":"descp3","lbl":"Descp3","width":"80"},
        {"cnm":"mnfc","lbl":"Manuf","width":"120"},
        {"cnm":"loc","lbl":"Loc","width":"100"},
        {"cnm":"area","lbl":"Area","width":"60"},
        {"cnm":"room","lbl":"Room","width":"60"},
        {"cnm":"rack","lbl":"Rack","width":"60"},
        {"cnm":"box","lbl":"Box","width":"60"},
        {"cnm":"qty","lbl":"Qty","width":"50"},
        {"cnm":"prate","lbl":"P Rate","width":"50"},
        {"cnm":"srate","lbl":"S Rate","width":"50"}
    ];

    var jsongrdAMC = [
        {"cnm":"id","lbl":"ID","width":""},
        {"cnm":"asdp","lbl":"Dept","width":""},
        {"cnm":"ascr","lbl":"TP","width":""},
        {"cnm":"sblc","lbl":"Sub Loc.","width":""},
        {"cnm":"loc","lbl":"Loc.","width":""},
        {"cnm":"eqtp","lbl":"EQTP","width":""},
        {"cnm":"asstid","lbl":"Asset","width":""},
        {"cnm":"mnfc","lbl":"Manuf","width":""},
        {"cnm":"model","lbl":"Model","width":""},
        {"cnm":"serial","lbl":"Serial","width":""},
        {"cnm":"sprttp","lbl":"SPRT Tp","width":""},
        {"cnm":"schdl","lbl":"SCHDL","width":""},
        {"cnm":"clnt","lbl":"Client","width":""}
    ];
