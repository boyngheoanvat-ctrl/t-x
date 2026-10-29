TARGET = build/SicBoMod.dylib
SRC = src/main.mm

all: $(TARGET)

$(TARGET): $(SRC)
	@mkdir -p build
	@echo "Đang biên dịch dylib cho iOS (arm64)..."
	clang++ -dynamiclib \
		-arch arm64 \
		-isysroot $$(xcrun --sdk iphoneos --show-sdk-path) \
		-fobjc-arc \
		$(SRC) \
		-o $(TARGET) \
		-framework Foundation
	@echo "Biên dịch thành công: $(TARGET)"

clean:
	rm -rf build
