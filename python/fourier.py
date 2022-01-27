import numpy as np
import matplotlib.pyplot as plt	
from matplotlib import cm
from torch import norm
def fourier_texture(x, y, frequency_x, frequency_y, amplitude_x, amplitude_y, phase_x, phase_y, k):
	"""
	Generates a 2D Fourier texture.
	"""
	
	x, y = np.meshgrid(x, y)

	f1 = np.zeros((x.shape[0], y.shape[0]))
	f2 = np.zeros((x.shape[0], y.shape[0]))

	for (freq_x, freq_y, amp_x, amp_y, ph_x, ph_y) in zip(frequency_x, frequency_y, amplitude_x, amplitude_y, phase_x, phase_y):
		f1 +=  amp_x * np.sin(2 * np.pi * freq_x * x + ph_x * np.pi / 180)
		f2 +=  amp_y * np.sin(2 * np.pi * freq_y * y + ph_y * np.pi / 180)
		

	
	return x, y, k * (f1*f2)



if __name__ == "__main__":

	x = np.linspace(-1, 1, 100)
	y = np.linspace(-1, 1, 100)

	x, y, f = fourier_texture(x, y, [1, 2, 3], [3, 4, 5], [0.01, 0.05, 0.1], [0.1, 0.05, 0.01], [-90, 30, 20], [-180, 50, 45], 0.01)
	
	fig, ax = plt.subplots(subplot_kw={"projection": "3d"})
	surf = ax.plot_surface(x, y, f ,linewidth=0, antialiased=False, cmap = cm.get_cmap("spring"), shade = True )
	fig.tight_layout()
	plt.show()