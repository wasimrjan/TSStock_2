using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace TSStock.Models
{
    public class Logic_Stock:Controller
    {
        MySQLContext db;
        public Logic_Stock(MySQLContext db)
        {
            this.db = db;
        }

        public JsonResult getMaterialList(JsonContainer json)
        {
            String sql = "select * from v_stock where 1 = 1";

            if (json.getAddlValueKey("loc") != "")
            {
                sql += " and loc = '" + json.getAddlValueKey("loc") + "'";
            }

            var s = db.VStocks.FromSqlRaw<Model_VStock>(sql).ToList();
            return Json(s);
        }

        public JsonResult getAvailableStock(JsonContainer json)
        {
            String sql = "select * from v_stock where avl > 0";

            if (json.getAddlValueKey("loc") != "")
            {
                sql += " and loc = '" + json.getAddlValueKey("loc") + "'";
            }

            var s = db.VStocks.FromSqlRaw<Model_VStock>(sql).ToList();
            return Json(s);
        }

        public JsonResult getStockOUT_Employee(JsonContainer json)
        {
            String sql = "select id,pno,enm from t_stock_out_emp where 1 = 1";

            if (json.getAddlValueKey("loc") != "")
            {
                sql += " and loc = '" + json.getAddlValueKey("loc") + "'";
            }

            var s = db.StockOUT_Employees.FromSqlRaw<Model_StockOUT_Employee>(sql).ToList();
            return Json(s);
        }

        public JsonResult getStockOUT_IssueEmployee(JsonContainer json)
        {
            String sql = "select id,spno,ctnm from t_stock_out_emp_issue where 1 = 1";

            if (json.getAddlValueKey("loc") != "")
            {
                sql += " and loc = '" + json.getAddlValueKey("loc") + "'";
            }

            var s = db.StockOUT_IssueEmployees.FromSqlRaw<Model_StockOUT_IssueEmployee>(sql).ToList();
            return Json(s);
        }


        public JsonResult getLocationAll()
        {
            String sql = "select id,loc from t_stock_loc where 1 = 1";

            var s = db.Locations.FromSqlRaw<Model_Location>(sql).ToList();
            return Json(s);
        }

        public JsonResult getLocationExcept(JsonContainer json)
        {
            String sql = "select id,loc from t_stock_loc where 1=1";

            if (json.getAddlValueKey("loc") != "")
            {
                sql += " and loc != '" + json.getAddlValueKey("loc") + "'";
            }

            var s = db.Locations.FromSqlRaw<Model_Location>(sql).ToList();
            return Json(s);
        }

        public JsonResult getSubLocations(JsonContainer json)
        {
            String sql = "select id,sloc,lcid,loc from t_stock_sub_loc where 1=1";

            if (json.getAddlValueKey("loc") != "")
            {
                sql += " and loc != '" + json.getAddlValueKey("loc") + "'";
            }

            var s = db.SubLocations.FromSqlRaw<Model_SubLocation>(sql).ToList();
            return Json(s);
        }

        public JsonResult getRacks(JsonContainer json)
        {
            String sql = "select id,ssloc,lcid,loc from t_stock_rack where 1=1";

            if (json.getAddlValueKey("loc") != "")
            {
                sql += " and loc != '" + json.getAddlValueKey("loc") + "'";
            }

            var s = db.Racks.FromSqlRaw<Model_Rack>(sql).ToList();
            return Json(s);
        }

        public JsonResult getProcessCodes(JsonContainer json)
        {
            String sql = "select 0 as id,'' as process,'' as code,'' as tp union select * from t_stock_process_code where 1=1";

            if (json.getFDTextKey("tp") != "")
            {
                sql += " and tp != '" + json.getFDTextKey("tp") + "'";
            }

            var s = db.ProcessCodes.FromSqlRaw<Model_ProcessCode>(sql).ToList();
            return Json(s);
        }
    }
}
