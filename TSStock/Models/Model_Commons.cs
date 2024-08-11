namespace TSStock.Models
{
    public class Model_Commons
    {

    }

    public class Model_StockOUT_Employee{
        public int id { get; set; }
        public string pno { get; set; }
        public string enm { get; set; }
   
    }

    public class Model_StockOUT_IssueEmployee
    {
        public int id { get; set; }
        public string spno { get; set; }
        public string ctnm { get; set; }

    }

    public class Model_Location
    {
        public int id { get; set; }
        public string loc { get; set; }

    }

    public class Model_SubLocation
    {
        public int id { get; set; }
        public string sloc { get; set; }
        public int lcid { get; set; }
        public string loc { get; set; }
    }

    public class Model_Rack
    {
        public int id { get; set; }
        public string ssloc { get; set; }
        public int lcid { get; set; }
        public string loc { get; set; }
    }

    public class Model_ProcessCode
    {
        public int id { get; set; }
        public string process { get; set; }
        public string code { get; set; }
        public string tp { get; set; }
    }

    public class Model_StockExcelLine
    {
        public int id { get; set; }
        public int seid { get; set; }
        public int sl { get; set; }
        public string skid { get; set; }
        public string dt { get; set; }
        public string loc { get; set; }
        public string sloc { get; set; }
        public string ssloc { get; set; }
        public string make { get; set; }
        public string uom { get; set; }
        public string mtcd { get; set; }
        public string material { get; set; }
        public string critical { get; set; }
        public int qty { get; set; }
        public string toloc { get; set; }
        public string tosloc { get; set; }
        public string tossloc { get; set; }
        public int wlvl { get; set; }
        public int rlvl { get; set; }
        public string scsts { get; set; }
        public string? rem { get; set; }
    }

    public class Model_DTLStock
    {
        public int id { get; set; }
        public int itid { get; set; }
        public string critical { get; set; }
        public string mtcd { get; set; }
        public string material { get; set; }
        public string make { get; set; }
        public string uom { get; set; }
        public string loc { get; set; }
        public string sloc { get; set; }
        public string ssloc { get; set; }
        public string sts { get; set; }
        public int sti { get; set; }
        public int sto { get; set; }
        public int tri { get; set; }
        public int tro { get; set; }
        public int adi { get; set; }
        public int ado { get; set; }
        public int scp { get; set; }
        public int rsv { get; set; }
        public int isr { get; set; }
        public int avl { get; set; }
    }

    public class Model_DTLStockLine
    {
        public int id { get; set; }
        public int skid { get; set; }
        public int sl { get; set; }
        public int itid { get; set; }
        public string? rem { get; set; }
        public string process { get; set; }
        public string bprocess { get; set; }
        public string dfdt { get; set; }
        public string dt { get; set; }
        public string dfcdt { get; set; }
        public string cdt { get; set; }
        public string mtcd { get; set; }
        public string material { get; set; }
        public string make { get; set; }
        public string uom { get; set; }
        public string loc { get; set; }
        public string sloc { get; set; }
        public string ssloc { get; set; }
        public string tloc { get; set; }
        public string tsloc { get; set; }
        public string? issueto { get; set; }
        public string? takenby { get; set; }
        public int qty { get; set; }
    
    }

    public class Model_SUMMStock
    {
        public int id { get; set; }
        public string critical { get; set; }
        public string mtcd { get; set; }
        public string material { get; set; }
        public string uom { get; set; }
        public string loc { get; set; }
        public int sti { get; set; }
        public int sto { get; set; }
        public int tri { get; set; }
        public int tro { get; set; }
        public int adi { get; set; }
        public int ado { get; set; }
        public int scp { get; set; }
        public int rsv { get; set; }
        public int isr { get; set; }
        public int avl { get; set; }
    }

    //seid,sl,skid,dt,loc,sloc,ssloc,make,uom,mtcd,material,critical,qty,toloc,tosloc,tossloc,wlvl,rlvl,scsts
}