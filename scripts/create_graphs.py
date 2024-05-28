import matplotlib.pyplot as plt

# Data from the experiments
beam_sizes = [1, 2, 3, 4, 5, 6, 7, 10, 15, 20]
bleu_scores = [13.6, 14.3, 14.5, 14.6, 14.6, 14.6, 14.7, 14.7, 14.7, 14.8]
times = [41, 20, 25, 33, 42, 48, 60, 86, 119, 156]

# Creating the graph for Beam Size vs BLEU Score
plt.figure(figsize=(10, 5))
plt.plot(beam_sizes, bleu_scores, marker='o', linestyle='-', color='green')
plt.title('Beam Size vs BLEU Score')
plt.xlabel('Beam Size')
plt.ylabel('BLEU Score')
plt.grid(True)
plt.xticks(beam_sizes)
plt.tight_layout()

# Show the first plot and save it
plt.savefig('./Beam_Size_vs_BLEU_Score.png')
plt.show()

# Creating the graph for Beam Size vs Time Taken
plt.figure(figsize=(10, 5))
plt.plot(beam_sizes, times, marker='o', linestyle='-', color='orange')
plt.title('Beam Size vs Time Taken')
plt.xlabel('Beam Size')
plt.ylabel('Time (seconds)')
plt.grid(True)
plt.xticks(beam_sizes)
plt.tight_layout()

# Show the second plot and save it
plt.savefig('./Beam_Size_vs_Time_Taken.png')
plt.show()
