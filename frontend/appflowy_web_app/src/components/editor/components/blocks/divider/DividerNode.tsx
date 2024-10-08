import { EditorElementProps, DividerNode as DividerBlock } from '@/components/editor/editor.type';
import React, { forwardRef, memo, useMemo } from 'react';

export const DividerNode = memo(
  forwardRef<HTMLDivElement, EditorElementProps<DividerBlock>>(
    ({ node: _node, children: children, ...attributes }, ref) => {
      const className = useMemo(() => {
        return `${attributes.className ?? ''} divider-node relative w-full rounded`;
      }, [attributes.className]);

      return (
        <div {...attributes} contentEditable={false}
             className={className}
        >
          <div
            contentEditable={false}
            className={'w-full px-1 py-2'}
          >
            <hr className={'border-line-border'} />
          </div>
          <div
            ref={ref}
            className={`absolute h-full w-full caret-transparent`}
          >
            {children}
          </div>
        </div>
      );
    },
  ),
);

export default DividerNode;
