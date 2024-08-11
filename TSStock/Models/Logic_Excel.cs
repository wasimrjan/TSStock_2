using ClosedXML.Excel;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Text.Json;

namespace TSStock.Models
{
    public class Logic_Excel:Controller
    {
        MySQLContext db;
        public Logic_Excel(MySQLContext db)
        {
            this.db = db;
        }

        public JsonResult uploadStockExcel(JsonContainer json)
        {
            String fl = json.getFDTextKey("flm");

            fl = fl.Substring(fl.IndexOf(",") + 1);

            var stream = new MemoryStream(Convert.FromBase64String(fl));
            XLWorkbook wb = new XLWorkbook(stream);
            IXLWorksheet worksheet = wb.Worksheet(1);



            String sql = "";

            sql = "select PROC_StockExcelAdd_Call_FN(NULL,";
            sql += CLCommon.SqlIFormat(json.getFDTextKey("opn")) + ",";
            sql += CLCommon.toDBFormat(json.getFDTextKey("dt")) + ",";
            sql += CLCommon.SqlIFormat(json.getAddlValueKey("lcid")) + ",";
            sql += CLCommon.SqlIFormat(json.getAddlValueKey("loc")) + ",";
            sql += CLCommon.SqlIFormat(json.getAddlValueKey("rem")) + ",'New',";
            sql += CLCommon.SqlIFormat(json.getAddlValueKey("uid")) + ",sysdate()) as id,'' as msg";
            CommonOutput co = db.CommonOutputs.FromSqlRaw<CommonOutput>(sql).FirstOrDefault();

            int i = 0;
            foreach (IXLRow row in worksheet.RowsUsed())
            {
                if (i > 0)
                {
                    string skid = row.Cell(2).Value.ToString();
                    string exdt = row.Cell(3).Value.ToString();
                    string umc = row.Cell(4).Value.ToString();
                    string mat = row.Cell(5).Value.ToString();
                    string make = row.Cell(6).Value.ToString();
                    string uom = row.Cell(7).Value.ToString();
                    string sloc = row.Cell(8).Value.ToString();
                    string ssloc = row.Cell(9).Value.ToString();
                    string qty = row.Cell(10).Value.ToString();
                    string crit = row.Cell(11).Value.ToString();
                    string toloc = row.Cell(12).Value.ToString();
                    string tosloc = row.Cell(13).Value.ToString();
                    string tossloc = row.Cell(14).Value.ToString();
                    string wlvl = row.Cell(15).Value.ToString();
                    string rlvl = row.Cell(16).Value.ToString();

                    if (skid != "" || mat != "")
                    {
                        if (qty == "")
                            qty = "0";

                        sql = "call PROC_StockExcel_LineAdd_Call(0,NULL,";
                        sql += CLCommon.SqlIFormat(co.id.ToString()) + ",";
                        sql += CLCommon.SqlIFormat(i.ToString()) + ",";
                        if (exdt != "")
                            sql += CLCommon.SqlIFormat(exdt) + ",";
                        else
                            sql += CLCommon.SqlIFormat(json.getFDTextKey("dt")) + ",";
                        sql += CLCommon.SqlIFormat(skid) + ",";
                        sql += CLCommon.SqlIFormat(json.getAddlValueKey("loc")) + ",";
                        sql += CLCommon.SqlIFormat(sloc) + ",";
                        sql += CLCommon.SqlIFormat(ssloc) + ",";
                        sql += CLCommon.SqlIFormat(make) + ",";
                        sql += CLCommon.SqlIFormat(uom) + ",";
                        sql += CLCommon.SqlIFormat(umc) + ",";
                        sql += CLCommon.SqlIFormat(mat) + ",";
                        if (crit != "Y")
                            sql += CLCommon.SqlIFormat("N") + ",";
                        else
                            sql += CLCommon.SqlIFormat("Y") + ",";
                        sql += CLCommon.SqlIFormat(toloc) + ",";
                        sql += CLCommon.SqlIFormat(tosloc) + ",";
                        sql += CLCommon.SqlIFormat(tossloc) + ",";
                        sql += CLCommon.SqlIFormat(wlvl) + ",";
                        sql += CLCommon.SqlIFormat(rlvl) + ",";
                        sql += CLCommon.SqlIFormat(qty) + ",'N')";

                        db.Database.ExecuteSqlRaw(sql);
                    }
                }

                i++;
            }

            sql = "select " + co.id.ToString() + " as id,'' as msg";
            return Json(db.CommonOutputs.FromSqlRaw<CommonOutput>(sql).FirstOrDefault());
        }

        public JsonResult updateStockExcel(JsonContainer json)
        {
            String seid = json.getFDTextKey("seid");

            String sql = "";

            sql = "call PROC_StockExcel(";
            sql += CLCommon.SqlIFormat(seid) + ")";
            db.Database.ExecuteSqlRaw(sql);

            return getStockExcelLines(json);
        }
        public JsonResult getStockExcelLines(JsonContainer json)
        {
            String sql = "select * from t_stock_excel_line where 1 = 1";

            if (json.getAddlValueKey("loc") != "")
            {
                sql += " and loc = '" + json.getAddlValueKey("loc") + "'";
            }

            if (json.getFDTextKey("seid") != "")
            {
                sql += " and seid = '" + json.getFDTextKey("seid") + "'";
            }

            var s = db.StockExcelLines.FromSqlRaw<Model_StockExcelLine>(sql).ToList();
            return Json(s);
        }

        public JsonResult ExportToExcel(JsonContainer json)
        {
            CommonOutput o = new CommonOutput();
            JsonDocument jd = JsonDocument.Parse(json.getFDTextKey("data"));
            JsonDocument jc = JsonDocument.Parse(json.getFDTextKey("columns"));
            int i=0,j;
            JsonElement je_jd = jd.RootElement;
            JsonElement je_jc = jc.RootElement;

            XLWorkbook w = new XLWorkbook();
            IXLWorksheet ws = w.Worksheets.Add("Export");

            for (j = 1; j <= je_jc.GetArrayLength(); j++)
            {
                ws.Cell(1, j).Value = je_jc[(j - 1)].GetProperty("lbl").ToString();
            }

            for (i = 1; i <= je_jd.GetArrayLength(); i++)
            {
                for (j = 1; j <= je_jc.GetArrayLength(); j++)
                {
                    string key = je_jc[(j - 1)].GetProperty("cnm").ToString();
                    ws.Cell((i+1), j).Value = je_jd[(i-1)].GetProperty(key).ToString();
                }
            }

            using (MemoryStream memoryStream = SaveWorkbookToMemoryStream(w))
            {
                o.msg = Convert.ToBase64String(memoryStream.ToArray());
            }

            return Json(o);
        }

        public static MemoryStream SaveWorkbookToMemoryStream(XLWorkbook workbook)
        {
            using (MemoryStream stream = new MemoryStream())
            {
                workbook.SaveAs(stream, new SaveOptions { EvaluateFormulasBeforeSaving = false, GenerateCalculationChain = false, ValidatePackage = false });
                return stream;
            }
        }
    }
}
