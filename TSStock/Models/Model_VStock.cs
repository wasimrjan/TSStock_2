using System.ComponentModel.DataAnnotations;

namespace TSStock.Models
{
    public class Model_VStock
    {
        [Key]
        public double skid { get; set; }
        public double itid { get; set; }
        public string sts { get; set; }
        public string mtcd { get; set; }
        public string material { get; set; }
        public string loc { get; set; }
        public string sloc { get; set; }
        public string ssloc { get; set; }
        public string make { get; set; }
        public string critical { get; set; }
        public string uom { get; set; }
        public double avl { get; set; }
        public double sti { get; set; }
        public double sto { get; set; }
        public double tri { get; set; }
        public double tro { get; set; }
        public double adi { get; set; }
        public double ado { get; set; }
        public double scp { get; set; }
        public double rsv { get; set; }
        public double isr { get; set; }
        
    }
}
