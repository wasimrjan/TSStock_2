using Microsoft.AspNetCore.Mvc;

namespace TSStock.Models
{
    public class Categories:Controller
    {
        MySQLContext db;
        public Categories(MySQLContext db)
        {
            this.db = db;
        }
        public JsonResult Process(JsonContainer o)
        {
            //if(o.AjaxID=="showGRID")
            //{
            //    return Json(db.t_categories.ToList());
            //}
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
