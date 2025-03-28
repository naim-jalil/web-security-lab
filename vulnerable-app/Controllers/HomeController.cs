using Microsoft.AspNetCore.Mvc;
using System.Diagnostics;
using VulnerableApp.Models;
using VulnerableApp.Data;

namespace VulnerableApp.Controllers
{
    public class HomeController : Controller
    {
        private readonly ApplicationDbContext _context;

        public HomeController(ApplicationDbContext context)
        {
            _context = context;
        }

        public IActionResult Index()
        {
            // VULNERABILITY: Displaying sensitive information
            ViewBag.DatabaseInfo = "SQL Server v15.0.4153.1 running on WEBSERVER01";
            return View();
        }

        public IActionResult About()
        {
            // VULNERABILITY: Reflected XSS
            if (!string.IsNullOrEmpty(Request.Query["name"]))
            {
                ViewBag.Name = Request.Query["name"]; // Unfiltered user input
            }
            return View();
        }

        public IActionResult Contact()
        {
            // VULNERABILITY: No CSRF protection
            return View();
        }

        [HttpPost]
        public IActionResult Contact(string name, string email, string message)
        {
            // VULNERABILITY: No input validation
            // VULNERABILITY: No CSRF protection
            
            // Store message directly without validation
            _context.Messages.Add(new Message {
                UserId = 1, // Default user
                Title = "Contact from " + name,
                Content = message,
                PostedDate = DateTime.Now,
                IsPublic = true
            });
            _context.SaveChanges();
            
            return RedirectToAction("ContactSuccess");
        }

        public IActionResult ContactSuccess()
        {
            return View();
        }

        public IActionResult Error()
        {
            // VULNERABILITY: Revealing too much information
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }
    }

    public class ErrorViewModel
    {
        public string RequestId { get; set; }
        public bool ShowRequestId => !string.IsNullOrEmpty(RequestId);
        // Additional detailed error information
        public string StackTrace { get; set; }
        public string ErrorSource { get; set; }
    }
}