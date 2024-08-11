using ClosedXML.Excel;
using DocumentFormat.OpenXml.Office2010.Excel;
using DocumentFormat.OpenXml.Spreadsheet;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using TSStock.Models;

namespace TSStock.Controllers
{
    public class DBController : Controller
    {
        MySQLContext db;
        public DBController(MySQLContext db) { 
            this.db = db;
        }
        public JsonResult Index([FromBody]JsonContainer json)
        {
            //Ajax ID Section Starts

            Logic_Stock lso = new Logic_Stock(db);

            if(json.AjaxID== "lstStockItem")
            {
                return lso.getMaterialList(json);
            }

            if (json.AjaxID == "lstIssueEmp")
            {
                return lso.getStockOUT_Employee(json);
            }

            if (json.AjaxID == "lstAvailableStock")
            {
                return lso.getAvailableStock(json);
            }

            if (json.AjaxID == "lstIssueCont")
            {
                return lso.getStockOUT_IssueEmployee(json);
            }

            if (json.AjaxID == "lstTranLocation")
            {
                return lso.getLocationExcept(json);
            }

            if (json.AjaxID == "lstTranLocation")
            {
                return lso.getLocationExcept(json);
            }

            if (json.AjaxID == "lstSubLoc")
            {
                return lso.getSubLocations(json);
            }

            if (json.AjaxID == "ProcessList")
            {
                return lso.getProcessCodes(json);
            }

            if (json.AjaxID == "StockExcelUPLD")
            {
                Logic_Excel o = new Logic_Excel(db);
                return o.uploadStockExcel(json);
            }

            if (json.AjaxID == "StockExcelList")
            {
                Logic_Excel o = new Logic_Excel(db);
                return o.getStockExcelLines(json);
            }

            if (json.AjaxID == "StockExcelUpdateDB")
            {
                Logic_Excel o = new Logic_Excel(db);
                return o.updateStockExcel(json);
            }

            if (json.AjaxID == "ExprtToExcel")
            {
                Logic_Excel o = new Logic_Excel(db);
                return o.ExportToExcel(json);
            }

            if (json.AjaxID == "DTLStock")
            {
                Logic_Reports o = new Logic_Reports(db);
                return o.getDTLStock(json);
            }

            if (json.AjaxID == "DTLStockLine")
            {
                Logic_Reports o = new Logic_Reports(db);
                return o.getDTLStockLine(json);
            }

            //Ajax ID Sections Ends


            if (json.FormName == "fmStockIN")
            {
                Logic_Transaction o = new Logic_Transaction(db);
                return o.Process(json,"StockIN","SI");
            }

            if (json.FormName == "fmStockOUT")
            {
                Logic_Transaction o = new Logic_Transaction(db);
                return o.Process(json, "StockOUT", "SO");
            }

            if (json.FormName == "fmStockTransfer")
            {
                Logic_Transaction o = new Logic_Transaction(db);
                return o.Process(json, "StockTransfer", "ST");
            }

            if (json.FormName == "fmStockINTransfer")
            {
                Logic_Transaction o = new Logic_Transaction(db);
                return o.Process(json, "InternalMovement", "IM");
            }

            if (json.FormName == "fmStockSCRAP")
            {
                Logic_Transaction o = new Logic_Transaction(db);
                return o.Process(json, "StockSCRAP", "SCP");
            }

            if (json.FormName == "fmStockAdjustment")
            {
                Logic_Transaction o = new Logic_Transaction(db);
                return o.Process(json, "StockAdjustment", "SA");
            }

            if (json.FormName== "fmSubLocation")
            {
                Logic_SubLocation o = new Logic_SubLocation(db);
                return o.Process(json);
            }

            return Json("");
            
        }
    }
}
