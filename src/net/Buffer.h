#ifndef BUFFER
#define BUFFER

#include <string>
#include <thread>
#include <iostream>
#include <deque>

using namespace std;

template<typename T>
class Buffer 
{
	private:
		deque<pair<T, int>> bufferList;

		condition_variable cond;
		mutex mutexLock;

	public:
		void add(T val, int ssrc = 0)
		{
			unique_lock<mutex> locker(mutexLock);
			aryList.push_back(make_pair(val, ssrc));
			locker.unlock();
			cond.notify_one();

			return;
		}

		pair<T, int> get(int index)
		{
			pair<T, int> temp;
			unique_lock<mutex> locker(mutexLock);
			temp = aryList[index];
			locker.unlock();
			cond.notify_one();

			return temp;
		}

		pair<T, int> getNext()
		{
			unique_lock<mutex> locker(mutexLock);
			pair<T, int> back = aryList.back();
			buffer.pop_back();
			locker.unlock();
			cond.notify_one();

			return back;
		}

		bool isEmpty()
		{
			bool empt;
			unique_lock<mutex> locker(mutexLock);
			empt = bufferList.empty();
			locker.unlock();

			return empt;
		}
}

#endif
