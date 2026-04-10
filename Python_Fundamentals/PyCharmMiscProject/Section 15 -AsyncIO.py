#Introduction
#AsyncIO- Asynchronous In and Out

#Getting Started
import asyncio
from asyncio import Task
from datetime import datetime

async def fetch_data (input_data: int) -> dict:
    print("Fetching data...")
    start_time: datetime = datetime.now()
    await asyncio.sleep(3)
    end_time: datetime = datetime.now()
    print("Data retrieved...")

    return {"input": input_data,
            "start_time": f"{start_time:%H:%M:%S}",
            "end_time": f"{end_time:%H:%M:%S}"}

async def main() -> None:
    task1: Task[dict] = asyncio.create_task(fetch_data(1))
    task2: Task[dict] = asyncio.create_task(fetch_data(2))

    data1: dict = await task1
    data2: dict = await task2

    print(f"{data1=}")
    print(f"{data2=}")

if __name__ == "__main__":
    asyncio.run(main = main())

#Task
#Scheduled, independently managed coroutine

import asyncio
from asyncio import create_task
from datetime import datetime

async def fetch_data (input_data: int, *, delay: int) -> dict:
    print("Fetching data...")

    #Times the code
    start_time: datetime = datetime.now()
    await asyncio.sleep(delay)
    end_time: datetime = datetime.now()
    print("Data retrieved...")

    return {"input": input_data,
            "start_time": f"{start_time:%H:%M:%S}",
            "end_time": f"{end_time:%H:%M:%S}"}


async def main() -> None:
    task: Task[dict] = asyncio.create_task(fetch_data(5, delay=30))

    try:
        data: dict = await asyncio.wait_for(task, timeout=3)
        print(data)
    except asyncio.TimeoutError:
        print("Timeout error")




if __name__ == "__main__":
    asyncio.run(main = main())

#Gather
#Scheduled, independently managed coroutine

import asyncio
from asyncio import create_task, Future
from datetime import datetime

async def fetch_data (input_data: int, *, delay: int, fails: bool) -> dict:
    print("Fetching data...")

    #Times the code
    start_time: datetime = datetime.now()
    await asyncio.sleep(delay)
    end_time: datetime = datetime.now()

    if fails:
        raise Exception("Something went wrong")

    print("Data retrieved...")
    return {"input": input_data,
            "start_time": f"{start_time:%H:%M:%S}",
            "end_time": f"{end_time:%H:%M:%S}"}


async def main() -> None:
    tasks: Future[tuple] = asyncio.gather(
        fetch_data(1, delay=1, fails=False),
        fetch_data(2, delay=2, fails=False),
        fetch_data(3, delay=3, fails=True),
        return_exceptions=True
    )

    results: tuple = await tasks
    for result in results:
        print(result)


if __name__ == "__main__":
    asyncio.run(main = main())
