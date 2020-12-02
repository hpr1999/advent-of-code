import Util

def part_one():
    num_strings = Util.read_file("01")
    nums = [int(x) for x in num_strings]

    for num in nums:
        if (2020-num in nums):
            return num * (2020-num)

def part_two():
    num_strings = Util.read_file("01")
    nums = [int(x) for x in num_strings]

    for i in range(len(nums)):
        for j in range(i+1,len(nums)):
            for k in range(j+1,len(nums)):
                if nums[i]+nums[j]+nums[k]==2020:
                    return nums[i]*nums[j]*nums[k]

print(part_two())
