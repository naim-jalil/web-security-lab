using Microsoft.Extensions.Logging;
using System;
using System.IO;

namespace VulnerableApp.Services
{
    public class InsecureLoggingService : ILogger
    {
        private readonly string _categoryName;

        public InsecureLoggingService(string categoryName)
        {
            _categoryName = categoryName;
        }

        public IDisposable BeginScope<TState>(TState state) => null;
        
        public bool IsEnabled(LogLevel logLevel) => true;
        
        public void Log<TState>(LogLevel logLevel, EventId eventId, TState state, Exception exception, Func<TState, Exception, string> formatter)
        {
            // VULNERABILITY: Logging sensitive information without redaction
            var message = formatter(state, exception);
            
            // VULNERABILITY: Writing logs to insecure location
            File.AppendAllText("C:\\logs\\app_log.txt", $"{DateTime.Now} - {_categoryName} - {logLevel}: {message}\n");
            
            // VULNERABILITY: No structured logging, making security monitoring difficult
            Console.WriteLine($"{DateTime.Now} - {_categoryName} - {logLevel}: {message}");
        }
    }

    public class InsecureLoggingServiceProvider : ILoggerProvider
    {
        public ILogger CreateLogger(string categoryName)
        {
            return new InsecureLoggingService(categoryName);
        }

        public void Dispose() { }
    }
}

        public IActionResult Users()
        {
            // VULNERABILITY: Missing function level access control
            // Should check if user is admin here
            
            var users = _context.Users.ToList();
            return View(users);
        }

        public IActionResult RunCommand(string command)
        {
            // VULNERABILITY: Command Injection
            if (string.IsNullOrEmpty(command))
            {
                return View();
            }
            
            try
            {
                // Execute the command directly
                var processInfo = new ProcessStartInfo("cmd.exe", "/c " + command)
                {
                    RedirectStandardOutput = true,
                    UseShellExecute = false,
                    CreateNoWindow = true
                };
                
                var process = Process.Start(processInfo);
                var output = process.StandardOutput.ReadToEnd();
                process.WaitForExit();
                
                ViewBag.Output = output;
            }
            catch (Exception ex)
            {
                ViewBag.Error = ex.Message;
            }
            
            return View();
        }

        public IActionResult Configuration()
        {
            // VULNERABILITY: Security misconfiguration
            // Showing sensitive configuration information
            var configInfo = new Dictionary<string, string>
            {
                { "Database Connection", _context.Database.GetConnectionString() },
                { "Server Path", Environment.CurrentDirectory },
                { "OS Version", Environment.OSVersion.ToString() },
                { "Machine Name", Environment.MachineName },
                { "User Domain", Environment.UserDomainName },
                { ".NET Version", Environment.Version.ToString() }
            };
            
            return View(configInfo);
        }

        [HttpPost]
        public IActionResult ExportUsers(string format)
        {
            // VULNERABILITY: Missing access control
            
            var users = _context.Users.ToList();
            
            if (format == "csv")
            {
                // VULNERABILITY: Information disclosure
                // Including sensitive info in export
                string csv = "UserId,Username,Password,Email,FullName,IsAdmin\n";
                foreach (var user in users)
                {
                    csv += $"{user.UserId},{user.Username},{user.Password},{user.Email},{user.FullName},{user.IsAdmin}\n";
                }
                
                return File(System.Text.Encoding.UTF8.GetBytes(csv), "text/csv", "users.csv");
            }
            
            return RedirectToAction("Users");
        }
    }
}
