// Generic quiz grading and reset functions
// Each quiz must define 'answers' and 'explanations' objects before loading this script

function gradeQuiz() {
  let score = 0;
  let totalQuestions = Object.keys(answers).length;
  let unanswered = [];

  // Check each question
  for (let q in answers) {
    let selected = document.querySelector(`input[name="${q}"]:checked`);
    let questionDiv = document.getElementById(q);
    let explanationDiv = document.getElementById('exp' + q.substring(1));

    if (!selected) {
      unanswered.push(q.substring(1));
      questionDiv.style.borderLeftColor = '#ffc107';
      continue;
    }

    let isCorrect = selected.value === answers[q];

    if (isCorrect) {
      score++;
      questionDiv.style.borderLeftColor = '#28a745';
      explanationDiv.className = 'explanation correct show';
      explanationDiv.innerHTML = '<strong>✓ Correct!</strong> ' + explanations[q].correct;
    } else {
      questionDiv.style.borderLeftColor = '#dc3545';
      explanationDiv.className = 'explanation incorrect show';
      explanationDiv.innerHTML = '<strong>✗ Incorrect.</strong> ' + explanations[q].incorrect + '<br><strong>Correct answer: ' + answers[q] + '</strong>';
    }
  }

  // Display score
  let summaryDiv = document.getElementById('scoreSummary');
  let percentage = Math.round((score / totalQuestions) * 100);
  let resultClass = percentage >= 70 ? 'correct' : 'incorrect';

  let summaryHTML = `<h2>Quiz Results 🎯</h2>
    <p class="${resultClass}" style="font-size: 24px;">You scored ${score} out of ${totalQuestions} (${percentage}%)</p>`;

  if (unanswered.length > 0) {
    summaryHTML += `<p style="color: #ffc107;">⚠ You did not answer question(s): ${unanswered.join(', ')}</p>`;
  }

  if (percentage >= 90) {
    summaryHTML += '<p>🌟 Excellent work! You have a strong understanding of the material.</p>';
  } else if (percentage >= 70) {
    summaryHTML += '<p>😊 Good job! You have a solid grasp of the material, but review the explanations for questions you missed.</p>';
  } else {
    summaryHTML += '<p>📚 Review the lecture material and try again. Pay attention to the explanations for each question.</p>';
  }

  summaryDiv.innerHTML = summaryHTML;
  summaryDiv.className = 'score-summary show';

  // Scroll to results
  summaryDiv.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
}

function resetQuiz() {
  // Clear all selections
  document.querySelectorAll('input[type="radio"]').forEach(input => input.checked = false);

  // Hide all explanations
  document.querySelectorAll('.explanation').forEach(exp => {
    exp.className = 'explanation';
    exp.innerHTML = '';
  });

  // Reset question borders
  document.querySelectorAll('.question').forEach(q => {
    q.style.borderLeftColor = '#4CAF50';
  });

  // Hide score summary
  document.getElementById('scoreSummary').className = 'score-summary';

  // Scroll to top
  window.scrollTo({ top: 0, behavior: 'smooth' });
}
