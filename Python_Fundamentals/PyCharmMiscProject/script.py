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
