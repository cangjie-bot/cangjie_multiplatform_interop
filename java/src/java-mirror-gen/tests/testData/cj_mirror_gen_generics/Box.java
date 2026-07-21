// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.


import java.util.List;
import java.util.Map;

public class Box<T> {
    public T element;
    public T[] array;
    public T[][] arrayOfArray;
    public List<T> listT;
    public List<T>[] arrayOfLists;
    public List<T[]> listOfArrays;
    public List<T[]>[] arrayOfListsOfArrays;
    public List<? extends T> covList;
    public List<? super T> contravList;
    public List<List<List<List<T>>>> listOfLists;

    public Box(T element) {}
    public T getElement() { return null; }
    public void putElement(T element) {}
    public List<T> getElementInList() { return null; }
    public T[] getArray() { return null; }
    public void putElementInArray(T[] elements) {}

    public void putRandomElementFrom(T[] array, T element, List<T> list) {}
    public void putRandomElementFrom(T element, T[] array, List<T> list) {}
    public void putRandomElementFrom(List<T> list, T[] array, T element) {}
    public <U> void putRandomElementFrom(List<U> list, U[] array, U element, List<List<U>> listOfLists) {}
    public <U extends Number> void putRandomElementFrom(List<U> list, U[] array, List<List<U>> listOfLists, U element) {}

    public <U extends Number, V extends Comparable<V>> void m(List<U> list, U[] array, List<List<U>> listOfLists, V element) {}
    public <U extends Number, V extends Comparable<V>> Map<U, V> m(List<U> list, List<List<V>> listOfLists) { return null; }
    public <U extends Number> List<? super U> m(List<? extends U> list) { return null; }
}
