using Microsoft.AspNetCore.Mvc;

namespace TSStock.Controllers
{
    public class TranController : Controller
    {
        public IActionResult StockIN()
        {
            return View();
        }

        public IActionResult StockOUT()
        {
            return View();
        }

        public IActionResult StockTransaction()
        {
            return View();
        }
        public IActionResult StockINTransaction()
        {
            return View();
        }

        public IActionResult StockAdjustment()
        {
            return View();
        }
        public IActionResult StockScrap()
        {
            return View();
        }

        public IActionResult StockExcel()
        {
            return View();
        }


    }
}
