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
            // Get the name parameter from the query string
            string name = Request.Query["name"].ToString();
            
            // Only set ViewBag.Name if the name is not empty
            if (!string.IsNullOrEmpty(name))
            {
                // Convert to a simple string value before setting it
                ViewBag.Name = name;
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