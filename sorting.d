import std.algorithm : remove;
import std.stdio;
import std.random : uniform;

static V[] insert(V)(V[] items, V newItem, ulong pos)
{
	items.length += 1;
	for (ulong i = items.length - 1; i > pos; i--)
		items[i] = items[i - 1];
	items[pos] = newItem;
	return items;
}

static ulong max(T)(T[] arr)
{
	ulong pos;
	ulong i = 1;

	for (; i < arr.length - 1; i++)
		if (arr[i] > arr[pos])
			pos = i;
	return pos;
}

static ulong min(T)(T[] arr)
{
	ulong pos;
	ulong i = 1;

	for (; i < arr.length - 1; i++)
		if (arr[i] < arr[pos])
			pos = i;
	return pos;
}

static T[] merge(T)(T[] left, T[] right)
{
	T[] result;

	while (left.length > 0 && right.length > 0)
	{
		if (left[0] <= right[0])
		{
			result ~= left[0];
			left = left.remove(0);
		}
		else
		{
			result ~= right[0];
			right = right.remove(0);
		}
	}
	while (left.length > 0)
	{
		result ~= left[0];
		left = left.remove(0);
	}
	while (right.length > 0)
	{
		result ~= right[0];
		right = right.remove(0);
	}
	return result;
}

T[] mergeSort(T)(T[] arr)
{
	if (arr.length <= 1)
		return arr;

	T[] left;
	T[] right;
	foreach (i; 0 .. arr.length)
	{
		if (i < arr.length / 2)
			left ~= arr[i];
		else
			right ~= arr[i];
	}
	left = mergeSort(left);
	right = mergeSort(right);

	return merge(left, right);
}

static ulong partition(T)(T[] arr, long lo, long hi)
{
	long pivot = cast(ulong)arr[hi];
	long i = (lo - 1);
	T tmp;

	for (long j = lo; j <= hi - 1; j++)
	{
		if (arr[j] <= pivot)
		{
			i++;
			tmp = arr[i];
			arr[i] = arr[j];
			arr[j] = tmp;
		}
	}
	tmp = arr[i + 1];
	arr[i + 1] = arr[hi];
	arr[hi] = tmp;
	return i + 1;
}

T[] quickSort(T)(T[] arr, long lo, long hi)
{
	ulong p;

	if (lo < hi)
	{
		p = partition(arr, lo, hi);
		arr = quickSort(arr, lo, p - 1);
		arr = quickSort(arr, p + 1, hi);
	}
	return arr;
}

T[] bubbleSort(T, alias op = "a > b")(T[] arr)
{
	bool changed = true;
	T a;
	T b;
	T tmp;

	while (changed)
	{
		changed = false;
		foreach (i; 0 .. arr.length - 1)
		{
			a = arr[i];
			b = arr[i + 1];
			if (mixin(op))
			{
				tmp = a;
				arr[i] = arr[i + 1];
				arr[i + 1] = tmp; 
				changed = true;
			}
		}
	}
	return arr;
}

T[] selectionSort(T, alias op = "a > b")(T[] arr)
{
	T[] sorted;
	ulong pos;
	ulong iter;

	foreach (i; 0 .. arr.length)
	{
		if (op == "a < b")
			pos = max(arr);
		else if (op == "a > b")
			pos = min(arr);
		sorted ~= arr[pos];
		arr.remove(pos);
		iter++;
	}
	return sorted;
}

bool isSorted(T, alias op = "a > b")(T[] arr)
{
	T a;
	T b;
	foreach (i; 0 .. arr.length - 1)
	{
		a = arr[i];
		b = arr[i + 1];
		if (mixin(op))
			return false;
	}
	return true;
}


void main()
{
	import std.datetime;

	int[] arr;
	long amount = 50000;

	foreach (i; 0 .. amount)
		arr ~= uniform(-50000, 50000);

	auto st = MonoTime.currTime;

	arr = bubbleSort(arr);

	writeln("Took ", MonoTime.currTime - st, " seconds to complete bubbleSort with ", arr.length, " items and it is sorted: ", isSorted(arr));
	
	arr.length = 0;
	foreach (i; 0 .. amount)
		arr ~= uniform(-50000, 50000);

	st = MonoTime.currTime;

	arr = selectionSort(arr);

	writeln("Took ", MonoTime.currTime - st, " seconds to complete selectionSort with ", arr.length, " items and it is sorted: ", isSorted(arr));

	arr.length = 0;
	foreach (i; 0 .. amount)
		arr ~= uniform(-50000, 50000);

	st = MonoTime.currTime;

	arr = mergeSort(arr);
	writeln("Took ", MonoTime.currTime - st, " seconds to complete mergeSort with ", arr.length, " items and it is sorted: ", isSorted(arr));

	arr.length = 0;
	foreach (i; 0 .. amount)
		arr ~= uniform(-50000, 50000);

	st = MonoTime.currTime;

	arr = quickSort!int(arr, 0, arr.length - 1);
	writeln("Took ", MonoTime.currTime - st, " seconds to complete quickSort with ", arr.length, " items and it is sorted: ", isSorted(arr));


}