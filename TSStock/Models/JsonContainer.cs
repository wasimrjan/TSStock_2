namespace TSStock.Models
{
    public class JsonContainer
    {
        public string AjaxID { get; set; }
        public string FormName { get; set; }
        public string CMN_WhereCL { get; set; }
        public string CMN_WhereData { get; set; }
        public List<CLFormData> WhereCLs { get; set; }
        public List<CLFormData> FormData { get; set; }
        public List<CLKeyData> Addl { get; set; }

        public List<CLTransaction> TranData { get; set; }

        public List<CLTransaction> TranData1 { get; set; }

        public List<CLTransaction> TranData2 { get; set; }

        public List<CLTransaction> TranData3 { get; set; }

        public string getFDTextIndex(int idx)
        {
            if (this.FormData.Count <= (idx + 1))
                return this.FormData[idx].text;
            else
                return "";
        }

        public string getFDValueIndex(int idx)
        {
            if (this.FormData.Count <= (idx + 1))
                return this.FormData[idx].value;
            else
                return "";
        }

        public string getFDTextKey(string key)
        {
            CLFormData o = this.FormData.Where(s=> s.key == key).FirstOrDefault();
            
            if(o != null)
                return o.text;
            else
                return "";
        }

        public string getFDValueKey(string key)
        {
            CLFormData o = this.FormData.Where(s => s.key == key).FirstOrDefault();

            if (o != null)
                return o.value;
            else
                return "";
        }


        public string getAddlValueKey(string key)
        {
            CLKeyData o = this.Addl.Where(s => s.key == key).FirstOrDefault();

            if (o != null)
                return o.value;
            else
                return "";
        }

        public string getAddlValueIndex(int idx)
        {
            if (this.Addl.Count <= (idx + 1))
                return this.Addl[idx].value;
            else
                return "";
        }
    }

    public class CLTransaction
    {
        public string itid { get; set; }
        public string mtcd { get; set; }
        public string material { get; set; }
        public string make { get; set; }
        public string loc { get; set; }
        public string sloc { get; set; }
        public string ssloc { get; set; }
        public string qty { get; set; }
        public string critical { get; set; }
        public string uom { get; set; }
        public string skid { get; set; }
        public string avl { get; set; }
        public string nqty { get; set; }
        public string pqty { get; set; }
        public string toloc { get; set; }
        public string tosloc { get; set; }
        public string act { get; set; }
        public string rem { get; set; }
    
    }
    public class CLKeyData
    {
        public string key { get; set; }
        public string value { get; set; }
    }

    public class CLFormData
    {
        public string key { get; set; }
        public string text { get; set; }
        public string value { get; set; }
    }

    public class DMLOutput
    {
        public string id { get; set; }
        public string msg { get; set; }
        public string adl { get; set; }

    }

}
