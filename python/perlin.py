import numpy as np
import matplotlib.pyplot as plt
from matplotlib import cm


def interpolate(a0, a1, t):
    """
    Linear interpolation.
    """

    return a0 + t * (a1 - a0)


def smoothstep(t):
    """
    Smoothstep function.
    """
    return t * t * (3 - 2 * t)


def generate_grid_gradient(ix, iy):
    """
    Generates a grid of gradients.
    """

    grid_gradient = np.random.uniform(0, 2*np.pi, (ix+1, iy+1))
    grid_gradient = np.stack(
        [np.cos(grid_gradient), np.sin(grid_gradient)], axis=2)
    return grid_gradient


def generate_perlin_noise(grid_gradient, p):
    """
    Generates a noise value for a given set of points.
    """

    # Seperate x and y
    x, y = p[..., 0], p[..., 1]

    # Get the grid coordinates for 4 corner
    ps = np.stack([np.array([np.floor(x), np.ceil(y)], dtype=np.int64),
                   np.array([np.ceil(x), np.ceil(y)], dtype=np.int64),
                   np.array([np.floor(x), np.floor(y)], dtype=np.int64),
                   np.array([np.ceil(x), np.floor(y)], dtype=np.int64)], axis=0).transpose((2, 3, 0, 1))

    p = np.tile(p, (4)).reshape((*p.shape[:2], 4, 2))

    # Get the distances between the points and the grid points and
    # calculate the dot product between gradients
    p_dot_vector = np.sum(
        grid_gradient[ps[..., 0], ps[..., 1]] * (p - ps), axis=3)

    # Calculate the interpolation ratios
    s1 = smoothstep(x - np.floor(x))
    s2 = smoothstep(y - np.floor(y))

    # First, interpolate between left and right points;
    # then, interpolate between top and bottom parts.
    return interpolate(
        interpolate(p_dot_vector[..., 2], p_dot_vector[..., 3], s1),
        interpolate(p_dot_vector[..., 0], p_dot_vector[..., 1], s1),
        s2)


def perlin_texture_2d(x_start, x_end, y_start, y_end, nx_points, ny_points, octaves):
    """
    Generates a 2D Fourier texture.
    """

    # Initialize the result tensor
    f = np.zeros((ny_points, nx_points))

    # For each octave (i.e., grid size)
    for octave in range(1, octaves+1):

        # Calculate the x and y transformation
        x_ = x_end*octave
        y_ = y_end*octave

        # Calculate the grid gradients
        grid_gradient = generate_grid_gradient(x_, y_)

        # Create mesh to work in 2D
        X, Y = np.meshgrid(np.linspace(x_start, x_, nx_points),
                           np.linspace(y_start, y_, ny_points))

        # Generate the Perlin noise and add it to the result
        f += generate_perlin_noise(grid_gradient, np.stack([X, Y], axis=2))

    return X, Y, f


if __name__ == "__main__":

    # Parameters
    x_start = 0
    y_start = 0
    x_end = 5
    y_end = 5
    nx_points = 100
    ny_points = 100
    octaves = [1]

    # Generate the texture
    for octave in octaves:
        X, Y, f = perlin_texture_2d(
            x_start, x_end, y_start, y_end, nx_points, ny_points, octave)

        fig, ax = plt.subplots(subplot_kw={"projection": "3d"})
        surf = ax.plot_surface(
            X, Y, f, linewidth=0, antialiased=False, cmap=cm.get_cmap("spring"), shade=True)
        fig.tight_layout()
        plt.figure()
        plt.imshow(f)
    plt.show()
