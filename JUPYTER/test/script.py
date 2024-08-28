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

def parallel_mandel(width, height, num_tasks, dview):
    """
    Ejecuta el cálculo del fractal Mandelbrot en paralelo.

    Args:
        width (int): Ancho del fractal.
        height (int): Alto del fractal.
        num_tasks (int): Número de tareas en paralelo.
        dview (ipyparallel.DirectView): Vista directa a los workers.

    Returns:
        tuple: Fractal generado y tiempo de ejecución en segundos.
    """
    # Definir los rangos de tareas para asegurar que se cubren todas las filas
    task_size = height // num_tasks
    remainder = height % num_tasks
    task_ranges = []
    start = 0
    for i in range(num_tasks):
        end = start + task_size + (1 if i < remainder else 0)
        task_ranges.append((start, end))
        start = end

    # Distribuir la función a los workers
    dview.push({
        'width': width,
        'height': height,
        'mandel': mandel,
    })

    # Ejecutar la función en paralelo y medir el tiempo
    start_time = time.time()
    results = dview.map_sync(lambda r: mandel(width, height, r[0], r[1]), task_ranges)
    end_time = time.time()
    parallel_time = end_time - start_time

    # Combinar los resultados
    fractal = ''.join(results)

    return fractal, parallel_time

def main():
    width = 10000
    height = 10000
    num_tasks_list = [1, 2, 4, 8, 16, 32, 64, 128, 256]
    resultados = {}

    # Crear el cliente de ipyparallel una sola vez
    try:
        client = ipp.Client("/home/jupyter/jupyter_shared/ipcontroller-client.json")
    except Exception as e:
        print(f"Error al conectar con ipyparallel: {e}")
        return

    dview = client[:]

    for num_tasks in num_tasks_list:
        tiempos = []
        for run in range(2):
            print(f"Ejecutando num_tasks={num_tasks}, ejecución {run + 1}/2")
            try:
                _, parallel_time = parallel_mandel(width, height, num_tasks, dview)
                tiempos.append(parallel_time)
                print(f"Tiempo de ejecución: {parallel_time:.4f} segundos")
            except Exception as e:
                print(f"Error al ejecutar parallel_mandel con num_tasks={num_tasks}: {e}")
                tiempos.append(float('inf'))  # Asignar infinito en caso de error
        # Calcular la media de los tiempos
        tiempo_medio = sum(tiempos) / len(tiempos)
        resultados[num_tasks] = tiempo_medio
        print(f"num_tasks={num_tasks}, tiempo medio: {tiempo_medio:.4f} segundos\n")

    # Cerrar el cliente
    client.close()

    # Imprimir resumen de resultados
    print("Resumen de tiempos medios de ejecución:")
    for num_tasks, avg_time in resultados.items():
        print(f"num_tasks={num_tasks}, tiempo medio={avg_time:.4f} segundos")

if __name__ == "__main__":
    main()
