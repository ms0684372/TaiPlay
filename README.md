# C# 命名規則

## Namespace：大駝峰（PascalCase）

```csharp
namespace MyProject
```

## Class：大駝峰（PascalCase）

```csharp
public class MyClass
```

## Enum：大駝峰（PascalCase），數值必填

```csharp
enum Subject
{
    Chinese = 0,
    Math = 1,
    English = 2,
}
```

## Interface：`I` 開頭 + 大駝峰（PascalCase）

```csharp
interface IMyInterface
```

## Function：大駝峰（PascalCase）

```csharp
public void Test()
```

## 變數

### Field（欄位）

- 建議使用 `private`
- 若需要對外公開，建議使用 Property
- `m_` + 小駝峰（camelCase）
- `m` 可加可不加

```csharp
private string m_name;
private string _name;
```

### Property（屬性）

- 大駝峰（PascalCase）

```csharp
public string Name { get; set; }
```

### 傳入參數、區域變數

- 小駝峰（camelCase）

```csharp
private void Add(int left, int right)
{
    int value = left + right;
    Console.WriteLine(value);
}
```
