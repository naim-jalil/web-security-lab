namespace VulnerableApp.Models
{
    public class User
    {
        public int UserId { get; set; }
        public string Username { get; set; }
        public string Password { get; set; } // Plain text password - intentionally insecure
        public string Email { get; set; }
        public string FullName { get; set; }
        public bool IsAdmin { get; set; }

        // Missing data validation attributes
    }
}