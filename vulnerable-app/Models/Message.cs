namespace VulnerableApp.Models
{
    public class Message
    {
        public int MessageId { get; set; }
        public int UserId { get; set; }
        public string Title { get; set; }
        public string Content { get; set; } // No HTML sanitization
        public DateTime PostedDate { get; set; }
        public bool IsPublic { get; set; }

        public User User { get; set; }
    }
}