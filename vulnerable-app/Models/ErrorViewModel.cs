namespace VulnerableApp.Models
{
    public class ErrorViewModel
    {
        public string RequestId { get; set; }
        public bool ShowRequestId => !string.IsNullOrEmpty(RequestId);
        // Additional detailed error information
        public string StackTrace { get; set; }
        public string ErrorSource { get; set; }
    }
}