import time
import ipyparallel as ipp

def mandel(width, height, first, last):
    minX = -2.0
    maxX = 1.0
    aspectRatio = 2

    chars = " .,-:;i+hHM$*#@ "

    yScale = (maxX - minX) * (float(height) / width) * aspectRatio

    fractal = ""
    for y in range(first, last):
        line = ""
        for x in range(width):
            c = complex(minX + x * (maxX - minX) / width, y * yScale / height - yScale / 2)
            z = c
            for char in chars:
                if abs(z) > 2:
                    break
                z = z * z + c
            line += char
        fractal += line + "\n"
    
    return fractal

def mandel_secuencial(width, height):
    return mandel(width, height, 0, height)

def parallel_mandel(width, height, num_tasks):
    # Create a client
    client = ipp.Client("/home/jupyter/jupyter_shared/ipcontroller-client.json")
    dview = client[:]
    
    # Define task sizes
    task_size = height // num_tasks
    
    # Distribute the function to workers
    dview.push({
        'width': width,
        'height': height,
        'mandel': mandel,
    })
    
    # Execute the function in parallel
    start_time = time.time()
    results = dview.map_sync(lambda task_index: mandel(width, height, task_index * task_size, (task_index + 1) * task_size), range(num_tasks))
    end_time = time.time()
    parallel_time = end_time - start_time
    
    # Combine results
    fractal = ''.join(results)
    
    return fractal, parallel_time

def main():
    width = 2000
    height = 1000
    num_tasks = 16

    # Timing sequential execution
    start_time = time.time()
    fractal_secuencial = mandel_secuencial(width, height)
    end_time = time.time()
    secuencial_time = end_time - start_time

    print("Secuencial time:", secuencial_time)

    # Timing parallel execution
    fractal_parallel, parallel_time = parallel_mandel(width, height, num_tasks)
    print("Parallel time:", parallel_time)

    # Optionally print the fractals
    # print("Secuencial fractal:\n", fractal_secuencial)
    # print("Paralell fractal:\n", fractal_parallel)

if __name__ == "__main__":
    main()
