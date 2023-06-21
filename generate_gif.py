from os import listdir, mkdir
from os.path import isfile, join
import imageio

# Create directory for GIFs
directory = "GIF"
parent_dir = '.\PLOTS'
path = join(parent_dir, directory)
mkdir(path)

# Create GIF for each scenario
for i in range(1,9):
    mypath = '.\PLOTS\Escenario_' + str(i)
    filenames = [join(mypath, f) for f in listdir(mypath) if isfile(join(mypath, f))]
    images = []
    for filename in filenames:
        images.append(imageio.imread(filename))
    imageio.mimsave(join('.\PLOTS\GIF','Esenario_'+ str(i)+'.gif'), images, duration = 0.7)

# Create GIF for each pilot distance
for i in [5,10,20]:
    mypath = '.\PLOTS\Piloto_' + str(i)
    filenames = [join(mypath, f) for f in listdir(mypath) if isfile(join(mypath, f))]
    images = []
    for filename in filenames:
        images.append(imageio.imread(filename))
    imageio.mimsave(join('.\PLOTS\GIF','Piloto_'+ str(i)+'.gif'), images, duration = 0.7)