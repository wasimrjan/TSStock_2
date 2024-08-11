using Microsoft.AspNetCore.Connections.Features;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
//using Microsoft.EntityFrameworkCore;
//using MySql.EntityFrameworkCore.Extensions;
//using NuGet.Protocol;

namespace TSStock.Models
{
    public class Logic_SubLocation:Controller
    {
        MySQLContext db;
        public Logic_SubLocation(MySQLContext db)
        {
            this.db = db;
        }
        public JsonResult Process(JsonContainer o)
        {
            if(o.AjaxID=="showGRID")
            {
                var s = db.SubLocations.FromSqlRaw<Model_SubLocation>("select * from t_stock_sub_loc").ToList();
                return Json(s);
            }
            else
            {
                String msg = "Data Saved To Database";
                if (o.AjaxID == "Delete")
                    msg = "Data Deleted From Database";

                String sql = "select FN_Mast_SubLocation(";
                sql += "'" + o.AjaxID + "',";
                if (o.getFDTextKey("id") == "")
                    sql += "NULL,";
                else
                    sql += "'" + o.getFDTextKey("id") + "',";
                sql += "'" + o.getFDTextKey("sloc") + "',";
                sql += "'1',";
                sql += "'Toolkit Store') as id,'" + msg + "' as msg";

                CommonOutput co = db.CommonOutputs.FromSqlRaw<CommonOutput>(sql).FirstOrDefault();

                return Json(co);
            }


            //if (o.AjaxID == "Save")
            //{
            //    t_category s = new t_category();
            //    s.cat = o.FormData[1].text;
            //    db.t_categories.Add(s);
            //    db.SaveChanges();
            //    return Json(new DMLOutput()
            //    {
            //        id = "1",
            //        msg = "Done"
            //    }); 
            //}
            return null;
        }

    }
}
