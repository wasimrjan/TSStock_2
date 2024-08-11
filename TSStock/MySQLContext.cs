using Microsoft.EntityFrameworkCore;
using TSStock.Models;

namespace TSStock
{
    public class MySQLContext:DbContext
    {
        public MySQLContext(DbContextOptions<MySQLContext> options)
        : base(options)
        {

        }

        public DbSet<Model_ProcessCode> ProcessCodes { get; set; }
        public DbSet<Model_Location> Locations { get; set; }
        public DbSet<Model_SubLocation> SubLocations { get; set; }
        public DbSet<Model_Rack> Racks { get; set; }
        public DbSet<Model_VStock> VStocks { get; set; }
        public DbSet<Model_StockOUT_Employee> StockOUT_Employees { get; set; }
        public DbSet<Model_StockOUT_IssueEmployee> StockOUT_IssueEmployees { get; set; }
        public DbSet<CommonOutput> CommonOutputs { get; set; }
        public DbSet<Model_StockExcelLine> StockExcelLines { get; set; }
        public DbSet<Model_DTLStock> DTLStocks { get; set; }
        public DbSet<Model_DTLStockLine> DTLStocksLines { get; set; }

        //public DbSet<Model_DTLStockLine> DTLStocksLines { get; set; }
    }
}
