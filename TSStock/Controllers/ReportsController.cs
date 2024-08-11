using Microsoft.AspNetCore.Mvc;

namespace TSStock.Controllers
{
    public class ReportsController : Controller
    {
        public IActionResult DTLStock()
        {
            return View();
        }
    }
}
