document.addEventListener('DOMContentLoaded', function() {
    
    // --- 1. LIVE SEARCH (Instant Table Filtering) ---
    const searchInput = document.querySelector('input[name="query"]');
    const tableBody = document.querySelector('tbody');

    if (searchInput && tableBody) {
        searchInput.addEventListener('input', function() {
            const filter = this.value.toLowerCase();
            const rows = tableBody.querySelectorAll('tr');

            rows.forEach(row => {
                const text = row.textContent.toLowerCase();
                // If text matches, show row, otherwise hide
                row.style.display = text.includes(filter) ? "" : "none";
                
                // Add a little fade effect when appearing
                if (text.includes(filter) && row.style.display === "") {
                    row.classList.add('animate__animated', 'animate__fadeIn');
                }
            });
        });
    }

    // --- 2. UNIVERSAL DELETE CONFIRMATION ---
    const deleteButtons = document.querySelectorAll('.text-danger, .btn-outline-danger');
    
    deleteButtons.forEach(btn => {
        // Removes inline 'onclick' for a cleaner event listener approach
        btn.removeAttribute('onclick'); 
        
        btn.addEventListener('click', function(e) {
            const confirmed = confirm("Are you sure? This action cannot be undone.");
            if (!confirmed) {
                e.preventDefault(); // Stops the link from firing
            }
        });
    });

    // --- 3. AUTO-HIDE FLASH ALERTS ---
    const alerts = document.querySelectorAll('.alert');
    alerts.forEach(alert => {
        setTimeout(() => {
            const bsAlert = new bootstrap.Alert(alert);
            bsAlert.close();
        }, 5000); // Closes automatically after 5 seconds
    });
});
