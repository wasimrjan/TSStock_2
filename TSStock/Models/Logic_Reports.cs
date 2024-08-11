using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace TSStock.Models
{
    public class Logic_Reports:Controller
    {
        MySQLContext db;
        public Logic_Reports(MySQLContext db)
        {
            this.db = db;
        }
        public JsonResult getDTLStock(JsonContainer json)
        {
            string sql = "select skid as id,itid,critical,mtcd,material,make,uom,loc,sloc,ssloc,avl,sti,sto,tri,tro,adi,ado,isr,scp,rsv,sts from v_stock where 1 = 1 ";
        
            string q = json.getFDTextKey("q");

            if (q != "")
                sql += "and (" + q.Substring(4) + ")";
        
            string loc = json.getAddlValueKey("loc");
            if (loc != ""){
                sql += " and loc = '" + loc + "'";
            }

            string sopn = json.getFDTextKey("sopn");
            string copn = json.getFDTextKey("copn");
        
            string critical = "";

            if (copn == "Non-Critical")
                critical = "N";
            else
                if(copn == "Critical" || copn == "Critical Only")
                    critical = "Y";

            if (sopn == "Available")
                sql += " and avl > 0";
            else
            if(sopn == "Zero Only")
                sql += " and avl = 0";

            if (critical != ""){
                if (copn == "Critical") 
                    sql += " and (critical = 'Y' or critical = 'N')";
                else
                {
                    sql += " and critical = '" + critical + "'";
                }
            }
        
            sql += " order by mtcd,material,make,loc,sloc,ssloc";

            var s = db.DTLStocks.FromSqlRaw<Model_DTLStock>(sql).ToList();
            return Json(s);
        }

        public JsonResult getDTLStockLine(JsonContainer json)
        {
            string skid = json.getFDTextKey("skid");
        
            string sql = "select rem,id,skid,sl,itid,process,bprocess,dfdt,date_format(dt,'%d.%m.%Y') as dt,dfcdt,date_format(cdt,'%d.%m.%Y') as cdt,mtcd,material,make,uom,qty,loc,sloc,ssloc,tloc,tsloc,issueto,takenby from v_stock_line where skid = '" + skid + "' ";
        
            string opn = json.getFDTextKey("opn");
            string stdt = json.getFDTextKey("stdt");
            string endt = json.getFDTextKey("endt");

            if (opn != ""){
                sql += " and bprocess = '" + opn + "'";
            }

            if (stdt != ""){
                sql += " and dt >= " + CLCommon.toDBFormat(stdt);
            }

            if (endt != ""){
                sql += " and dt <= " + CLCommon.toDBFormat(endt);
            }
        
            sql += " order by id desc";
            
            var s = db.DTLStocksLines.FromSqlRaw<Model_DTLStockLine>(sql).ToList();
            return Json(s);
        }
    }
}
