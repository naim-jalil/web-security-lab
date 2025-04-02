using VulnerableApp.Models;
using VulnerableApp.Data;
using System.Linq;
using Microsoft.Extensions.DependencyInjection;

namespace VulnerableApp.Services
{
    public interface IAuthService
    {
        bool ValidateCredentials(string username, string password);
        User GetUserByUsername(string username);
    }

    public class InsecureAuthService : IAuthService
    {
        private readonly IServiceScopeFactory _scopeFactory;

        public InsecureAuthService(IServiceScopeFactory scopeFactory)
        {
            _scopeFactory = scopeFactory;
        }
        public bool ValidateCredentials(string username, string password)
        {
            // Create a new scope to resolve the DbContext
            using (var scope = _scopeFactory.CreateScope())
            {
                var dbContext = scope.ServiceProvider.GetRequiredService<ApplicationDbContext>();
                
                // VULNERABILITY: Direct string comparison of passwords (no hashing)
                var user = dbContext.Users.FirstOrDefault(u => u.Username == username);
                return user != null && user.Password == password; // Insecure comparison
            }
        }

        public User GetUserByUsername(string username)
        {
            // Create a new scope to resolve the DbContext
            using (var scope = _scopeFactory.CreateScope())
            {
                var dbContext = scope.ServiceProvider.GetRequiredService<ApplicationDbContext>();
                
                // VULNERABILITY: No input validation or sanitization
                return dbContext.Users.FirstOrDefault(u => u.Username == username);
            }
        }
    }
}