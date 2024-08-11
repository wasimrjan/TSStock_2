using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace TSStock.Models
{
    public class Logic_Transaction : Controller
    {
        MySQLContext db;
        public Logic_Transaction(MySQLContext db)
        {
            this.db = db;
        }
        public JsonResult Process(JsonContainer o,string ProcessTP,string SubProcessTP)
        {
            if (o.AjaxID == "showGRID")
            {
                var s = db.SubLocations.FromSqlRaw<Model_SubLocation>("select * from t_stock_sub_loc").ToList();
                return Json(s);
            }
            else
            {
                String msg = "Data Saved To Database";

                String sql = "";

                sql = "select FN_StockProcessAdd_Call(NULL,'" + ProcessTP + "',";
                sql += "" + CLCommon.SqlIFormat(o.getFDTextKey("descp")) + ",";
                sql += "" + CLCommon.SqlIFormat(o.getFDTextKey("loc")) + ",";
                sql += "" + CLCommon.SqlIFormat(o.getFDTextKey("ispno")) + ",";
                sql += "" + CLCommon.SqlIFormat(o.getFDTextKey("isto")) + ",";
                sql += "" + CLCommon.SqlIFormat(o.getFDTextKey("tknspno")) + ",";
                sql += "" + CLCommon.SqlIFormat(o.getFDTextKey("tknby")) + ",";
                sql += CLCommon.toDBFormat(o.getFDTextKey("dt")) + ",";
                sql += "" + CLCommon.SqlIFormat(o.getFDTextKey("cby")) + ") as id,'' as msg";

                //db.Database.ExecuteSqlRaw(sql);

                CommonOutput nid = db.CommonOutputs.FromSqlRaw<CommonOutput>(sql).FirstOrDefault();

                int i = 1;
                foreach(CLTransaction t in o.TranData)
                {
                    if (t.itid != "")
                    {
                        sql = "call PROC_StockProcessAdd_Line(";
                        sql += nid.id.ToString() + ",";
                        sql += "'" + (i).ToString() + "',";
                        sql += "" + CLCommon.toDBFormat(o.getFDTextKey("dt")) + ",";
                        sql += "'" + ProcessTP + "','" + SubProcessTP + "',";
                        sql += "" + CLCommon.SqlIFormat(o.getAddlValueKey("loc")) + ",";
                        sql += "" + CLCommon.SqlIFormat(t.sloc) + ",";
                        sql += "" + CLCommon.SqlIFormat(t.ssloc) + ",";
                        sql += "" + CLCommon.SqlIFormat(t.make) + ",";
                        sql += "" + CLCommon.SqlIFormat(t.uom) + ",";
                        sql += "" + CLCommon.SqlIFormat(t.itid) + ",";
                        sql += "" + CLCommon.SqlIFormat(t.mtcd) + ",";
                        sql += "" + CLCommon.SqlIFormat(t.material) + ",";
                        sql += "" + CLCommon.SqlIFormat(t.critical) + ",";
                        sql += "" + CLCommon.SqlIFormat(t.qty) + ",";
                        sql += "" + CLCommon.SqlIFormat(t.pqty) + ",";
                        sql += "" + CLCommon.SqlIFormat(t.nqty) + ",";
                        sql += "" + CLCommon.SqlIFormat(t.act) + ",";
                        sql += "" + CLCommon.SqlIFormat(t.toloc) + ",";
                        sql += "" + CLCommon.SqlIFormat(t.tosloc) + ",";
                        sql += "" + CLCommon.SqlIFormat(t.rem) + ",";
                        sql += "'" + t.skid + "')";

                        db.Database.ExecuteSqlRaw(sql);
                        i++;
                    }
                }

                sql = "call PROC_StockSetup("+ nid.id.ToString() + ")";
                
                db.Database.ExecuteSqlRaw(sql);


                if (ProcessTP == "StockOUT")
                {
                    sql = "call PROC_StockEmployeeIssue(";
                    sql += "" + CLCommon.SqlIFormat(o.getFDTextKey("tknspno")) + ",";
                    sql += "" + CLCommon.SqlIFormat(o.getFDTextKey("tknby")) + ",";
                    sql += "" + CLCommon.SqlIFormat(o.getAddlValueKey("lcid")) + ",";
                    sql += "" + CLCommon.SqlIFormat(o.getAddlValueKey("loc")) + "";
                    sql += ")";

                    db.Database.ExecuteSqlRaw(sql);

                }

                CommonOutput co = new CommonOutput(); 
                    //= db.CommonOutputs.FromSqlRaw<CommonOutput>(sql).FirstOrDefault();

                return Json(co);
            }
        }
    }
}
