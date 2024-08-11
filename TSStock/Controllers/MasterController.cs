using Microsoft.AspNetCore.Mvc;

namespace TSStock.Controllers
{
    public class MasterController : Controller
    {
        public IActionResult SubLocation()
        {
            return View();
        }
    }
}
