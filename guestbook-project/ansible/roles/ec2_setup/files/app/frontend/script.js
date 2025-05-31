document.addEventListener('DOMContentLoaded', () => {
    loadReviews();
  
    const form = document.getElementById('review-form');
    form.addEventListener('submit', async (e) => {
      e.preventDefault();
  
      const text = document.getElementById('text').value;
      const image = document.getElementById('image').files[0];
  
      const formData = new FormData();
      formData.append('text', text);
      formData.append('image', image);
  
      try {
        const res = await fetch('/upload', {
          method: 'POST',
          body: formData
        });
  
        if (res.ok) {
          form.reset();
          loadReviews();
        } else {
          alert('Failed to submit review.');
        }
      } catch (err) {
        console.error('Submission failed:', err);
        alert('An error occurred.');
      }
    });
  
    setInterval(loadReviews, 10000); // refresh every 10s
  });
  
  async function loadReviews() {
    try {
      const res = await fetch('/reviews');
      const reviews = await res.json();
  
      const container = document.getElementById('reviews-container');
      container.innerHTML = '';
  
      reviews.forEach(review => {
        const div = document.createElement('div');
        div.className = 'review';
  
        const thumbPath = encodeURIComponent(review.thumb_url);
  
        div.innerHTML = `
          <p><strong>${new Date(review.created_at).toLocaleString()}</strong></p>
          <p>${review.text}</p>
          <img src="/image?key=${thumbPath}" alt="Review image" />
          <hr />
        `;
  
        container.appendChild(div);
      });
    } catch (err) {
      console.error('Failed to load reviews:', err);
    }
  }