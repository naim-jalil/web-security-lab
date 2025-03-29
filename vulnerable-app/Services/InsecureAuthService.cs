using VulnerableApp.Models;
using VulnerableApp.Data;
using System.Linq;

namespace VulnerableApp.Services
{
    public interface IAuthService
    {
        bool ValidateCredentials(string username, string password);
        User GetUserByUsername(string username);
    }

    public class InsecureAuthService : IAuthService
    {
        private readonly ApplicationDbContext _context;

        public InsecureAuthService(ApplicationDbContext context)
        {
            _context = context;
        }

        public bool ValidateCredentials(string username, string password)
        {
            // VULNERABILITY: Direct string comparison of passwords (no hashing)
            var user = _context.Users.FirstOrDefault(u => u.Username == username);
            return user != null && user.Password == password; // Insecure comparison
        }

        public User GetUserByUsername(string username)
        {
            // VULNERABILITY: No input validation or sanitization
            return _context.Users.FirstOrDefault(u => u.Username == username);
        }
    }
}