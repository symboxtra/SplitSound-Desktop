#include <iostream>
#include <gtest/gtest.h>

#include "BroadcastAddress.h"

TEST(TestBroad, HandleLocalHost)
{
	for(auto const&  addr : getBroadcastAddress())
		EXPECT_STRNE("127.0.0.1", addr.c_str());
}
