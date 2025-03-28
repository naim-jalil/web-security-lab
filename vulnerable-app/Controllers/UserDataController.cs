using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Cors;
using VulnerableApp.Data;
using System.Linq;

namespace VulnerableApp.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    // VULNERABILITY: Overly permissive CORS policy
    [EnableCors(PolicyName = "AllowAll")]
    public class UserDataController : ControllerBase
    {
        private readonly ApplicationDbContext _context;
        
        public UserDataController(ApplicationDbContext context)
        {
            _context = context;
        }
        
        [HttpGet]
        public IActionResult GetUsers()
        {
            // VULNERABILITY: Missing authentication
            // VULNERABILITY: Missing authorization
            // VULNERABILITY: Excessive data exposure
            return Ok(_context.Users.Select(u => new { 
                u.UserId, 
                u.Username, 
                u.Email, 
                u.Password, // Exposing passwords!
                u.IsAdmin 
            }).ToList());
        }

        [HttpGet("{id}")]
        public IActionResult GetUserDetails(int id)
        {
            // VULNERABILITY: IDOR vulnerability
            var user = _context.Users.Find(id);
            if (user == null)
            {
                return NotFound();
            }

            // VULNERABILITY: Exposing sensitive data
            return Ok(new {
                user.UserId,
                user.Username,
                user.Password, // Exposing password
                user.Email,
                user.FullName,
                user.IsAdmin
            });
        }
    }
}