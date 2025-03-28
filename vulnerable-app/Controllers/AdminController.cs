using Microsoft.AspNetCore.Mvc;
using VulnerableApp.Data;
using VulnerableApp.Models;
using System.Linq;
using System;
using System.Diagnostics;

namespace VulnerableApp.Controllers
{
    public class AdminController : Controller
    {
        private readonly ApplicationDbContext _context;

        public AdminController(ApplicationDbContext context)
        {
            _context = context;
        }

        public IActionResult Dashboard()
        {
            // VULNERABILITY: Authentication bypass via parameter
            if (Request.Query.ContainsKey("debug") && Request.Query["debug"] == "true")
            {
                // VULNERABILITY: Debug backdoor bypasses authentication
                ViewBag.Message = "Debug mode activated - authentication bypassed";
                return View();
            }

            // VULNERABILITY: Weak authentication check
            if (HttpContext.Session.GetString("IsAdmin") != "True")
            {
                return RedirectToAction("Login", "Account");
            }
            
            ViewBag.UserCount = _context.Users.Count();
            ViewBag.ProductCount = _context.Products.Count();
            ViewBag.OrderCount = _context.Orders.Count();
            
            return View();
        }